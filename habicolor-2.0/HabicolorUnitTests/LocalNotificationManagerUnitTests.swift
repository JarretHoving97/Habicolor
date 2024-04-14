//
//  HabicolorUnitTestss.swift
//  HabicolorUnitTestss
//
//  Created by Jarret Hoving on 14/04/2024.
//

import XCTest

class NotificationManagerSpy {
    
    var localNotifications: [String: [String]] = [:]
    
    init() {}
}
extension NotificationManagerSpy {
    
    func addNotification(for habit: String, _ notification: String) {
        if self.localNotifications.contains(where: { $0.key == habit }) {
            self.localNotifications[habit]?.append(notification)
        } else {
            self.localNotifications[habit] = [notification]
        }
    }
    
    func addMultipleNotifications(for habit: String, _ notifications: [String]) {
        if self.localNotifications.contains(where: { $0.key == habit }) {
            self.localNotifications[habit]! += notifications
        } else {
            self.localNotifications[habit] = notifications
        }
    }
    
    func deleteNotification(_ notification: String, for habit: String) {
        localNotifications[habit]?.removeAll(where: {$0 == notification})
    }
    
    func fetchNotifications(for habit: String) -> [String] {
        return localNotifications[habit] ?? []
    }
}

final class LocalNotificationManagerTests: XCTestCase {
    
    func test_init() {
        let sut = makeSUT()
        XCTAssertNotNil(sut)
    }
    
    func test_notificationManager_areNotNilAfterStoring() {
        let sut = makeSUT()
        let habit = makeHabit()
        
        sut.addNotification(for: habit, notificationExample())
        XCTAssertNotNil(sut.localNotifications[habit])
    }
    
    func test_notificationManager_haveMultileNotificationsStored() {
        let sut = makeSUT()
        let habit = makeHabit()
        
        sut.addMultipleNotifications(for: habit, [notificationExample(), notificationExample()])
        XCTAssertEqual(sut.localNotifications[habit]?.count, 2)
    }
    
    func test_notificationManager_doesDeleteNotificationForHabit() {
        let sut = makeSUT()
        let habit = makeHabit()
        let notification = notificationExample()
        
        sut.addNotification(for: habit, notification)
        sut.deleteNotification(notification, for: habit)
        
        XCTAssertEqual(sut.localNotifications[habit], [])
    }
    
    func test_notificationManager_deletesAllNotificationsWhenHabitGetsDeleted() {
        let sut = makeSUT()
        let habit = makeHabit()
        let notification = notificationExample()
        
        sut.addNotification(for: habit, notification)
        sut.localNotifications.removeValue(forKey: habit)
        
        XCTAssertNil(sut.localNotifications[habit])
    }
    
    func test_notificationManager_deliversEmptyNotificationsForHabit() {
        let sut = makeSUT()
        let habit = makeHabit()
        
        XCTAssertTrue(sut.fetchNotifications(for: habit).isEmpty)
    }
    
    func test_notificationManager_deliversNotificationsForHabit() {
        
        let sut = makeSUT()
        let habit = makeHabit()
        
        sut.addMultipleNotifications(for: habit, [notificationExample(), notificationExample()])
        XCTAssertTrue(!sut.fetchNotifications(for: habit).isEmpty)
    }
    
    // MARK: Helpers
    
    func makeSUT() -> NotificationManagerSpy {
        return NotificationManagerSpy()
    }
    
    func notificationExample() -> String {
        return UUID().uuidString
    }
    
    func makeHabit() -> String {
        return UUID().uuidString
    }
}

