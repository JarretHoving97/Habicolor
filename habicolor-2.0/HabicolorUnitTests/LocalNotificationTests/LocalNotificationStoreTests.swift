//
//  HabicolorUnitTestss.swift
//  HabicolorUnitTestss
//
//  Created by Jarret Hoving on 14/04/2024.
//

import XCTest
import Habicolor

final class LocalNotificationStoreTests: XCTestCase {
    
    func test_store_isNotEmptyAfterAddingNotification() async throws {
        
        let sut = makeSUT()
        try await sut.addNotification(notificationExample())
        
        let result = await sut.getPendingRequests()
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func test_store_doesNotFailAddingNotification() async {
        let sut = makeSUT(with: NotificationCenterSpy(authorizationStatus: .authorized))
        
        var error: Error?
        
        do {
            try await sut.addNotification(notificationExample())
        } catch let e {
            error = e
        }
        
        XCTAssertNil(error, "Expected to be nil, because the localnotifications has been authorized")
    }
    
    func test_store_addingNotificationFails() async {
        
        let sut = makeSUT(with: NotificationCenterSpy(authorizationStatus: .denied))
        
        var error: Error?
        
        do {
            try await sut.addNotification(notificationExample())
        } catch let e {
            error = e
        }
        
        XCTAssertNotNil(error, "Expected to be a error because local notification is not authorized")
    }
    
    
    func test_store_loadsNotifications() async throws {
        let sut = makeSUT()
        
        try await sut.addNotification(notificationExample())
        try await sut.addNotification(notificationExample())
        
        let result = await sut.getPendingRequests()
        
        XCTAssertEqual(result.count, 2)
    }
    
    func test_store_removesNotificationById() async throws {
        
        let sut = makeSUT()
        
        let notification = notificationExample()
        
        try await sut.addNotification(notification)
        try await sut.addNotification(notificationExample())
        
        sut.removePendingRequests(with: [notification.id])
        
        let result = await sut.getPendingRequests()
        
        XCTAssertEqual(result.count, 1)
    }
    
    
    // MARK: Helpers
    
    private func makeSUT(with authorizer: NotificationAuthorizer = NotificationCenterSpy(authorizationStatus: .authorized)) -> LocalNotificationStore {
        
        return NotificationStoreSpy(authorizer: authorizer)
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
