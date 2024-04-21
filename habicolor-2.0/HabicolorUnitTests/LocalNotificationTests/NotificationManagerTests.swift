//
//  NotificationManagerTests.swift
//  HabicolorUnitTests
//
//  Created by Jarret Hoving on 21/04/2024.
//

import XCTest
import Habicolor

struct LocalNotificationManager {
    
    private let store: LocalNotificationStore
    
    init(store: LocalNotificationStore) {
        self.store = store
    }
    
    enum Error: Swift.Error {
        case updateLocalNotificationFailed
    }
    
    func create(notification: LocalNotification) async throws {
        try await store.addNotification(notification)
    }
    
    func create(notifications: [LocalNotification]) async throws {
        for notification in notifications {
            try await store.addNotification(notification)
        }
    }
    
    func delete(with identifier: String) async {
        store.removePendingRequests(with: [identifier])
    }
    
    func fetchAll() async -> [LocalNotification] {
        return await store.getPendingRequests()
    }
    
    func update(for id: String, notification: LocalNotification) async throws {
        // get pending notifications
        var notifications = await fetchAll()
        
        guard let index = notifications.firstIndex(where: {$0.id == id}) else {
            throw Error.updateLocalNotificationFailed
        }
        
        notifications.insert(notification, at: index)
        
        try await create(notifications: notifications)
    }
}

final class NotificationManagerTests: XCTestCase {
    
    func test_manager_canStoreNotification() async throws {
        let sut = makeSUT()
        
        let notification = notificationExample()
        try await sut.create(notification: notification)
        
        let result = await sut.fetchAll()
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_manager_storingNotificationFails() async  {
        let sut = makeSUT(with: NotificationCenterSpy(authorizationStatus: .notDetermined))
        
        var error: Error?
        
        do {
            try await sut.create(notification: notificationExample())
        } catch let e {
            error = e
        }
        
        XCTAssertNotNil(error)
    }
    
    func test_manager_canStoreMultipleNotifications() async throws {
        let sut = makeSUT()
        let notifications = [notificationExample(), notificationExample(), notificationExample()]
        
        try await sut.create(notifications: notifications)
        let result = await sut.fetchAll()
        
        XCTAssertEqual(notifications.count, result.count)
    }
    
    func test_manager_storingMultipleNotificationsFails() async  {
        let sut = makeSUT(with: NotificationCenterSpy(authorizationStatus: .denied))
        let notifications = [notificationExample(), notificationExample(), notificationExample()]
        
        var error: Error?
        do {
            try await sut.create(notifications: notifications)
        } catch let e {
            error = e
        }
    
        XCTAssertNotNil(error)
    }
    
    func test_manager_deletesSpecificNotification() async throws {
        let sut = makeSUT()
        let notification = notificationExample()
        let notifications = [notification, notificationExample(), notificationExample()]
        
        try await sut.create(notifications: notifications)
        await sut.delete(with: notification.id)
        let result = await sut.fetchAll()
        
        XCTAssertFalse((result.map {$0.id}).contains(notification.id))
    }
    
    func test_manager_updatesSpecificNotificationValue() async throws {
        let sut = makeSUT()
        let notificationToUpdate = notificationExample()
        
        var updatedNotification = notificationToUpdate
        updatedNotification.subtitle = "Nice other body"
        
        let notifications = [notificationToUpdate, notificationExample(), notificationExample()]
        try await sut.create(notifications: notifications)
        try await sut.update(for: notificationToUpdate.id, notification: updatedNotification)
        let result = await sut.fetchAll()
        
        XCTAssertTrue(result.map {$0.subtitle}.contains(updatedNotification.subtitle))
    }
    
    func test_manager_fetchNotificationForCategory() async throws {
        
    }
    
    
    // MARK: Helpers
    private func makeSUT(with authorizer: NotificationAuthorizer = NotificationCenterSpy(authorizationStatus: .authorized)) -> LocalNotificationManager {
        return LocalNotificationManager(store: NotificationStoreSpy(authorizer: authorizer))
    }
    
    private func notificationExample() -> LocalNotification {
        return LocalNotification(
            id: UUID().uuidString,
            title: "title",
            subtitle: "Nice body",
            sound: .default,
            userInfo: [:],
            dateComponents: DateComponents(),
            repeats: true
        )
    }
}
