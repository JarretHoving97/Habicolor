//
//  NotificationManagerTests.swift
//  HabicolorUnitTests
//
//  Created by Jarret Hoving on 21/04/2024.
//

import XCTest
import Habicolor

struct LocalNotificationManager {
    
    let store: LocalNotificationStore
    
    func create(notification: LocalNotification) async throws {
        try await store.addNotification(notification)
    }
    
    func delete(with identifier: String) async {
        store.removePendingRequests(with: [identifier])
    }
    
    func fetchAll() async -> [LocalNotification] {
        return await store.getPendingRequests()
    }
}

final class NotificationManagerTests: XCTestCase {
    
    
    
}
