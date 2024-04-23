//
//  LocalNotificationManager.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 21/04/2024.
//

import Foundation

public struct LocalNotificationManager {
    
    private let store: LocalNotificationStore
    
    public init(store: LocalNotificationStore = AppLocalNotificationManager()) {
        self.store = store
    }
    
    enum Error: Swift.Error {
        case updateLocalNotificationFailed
    }
    
    public func create(notification: LocalNotification) async throws {
        try await store.addNotification(notification)
    }
    
    public func create(notifications: [LocalNotification]) async throws {
        for notification in notifications {
            try await store.addNotification(notification)
        }
    }
    
    public func delete(with identifier: String) async {
        store.removePendingRequests(with: [identifier])
    }
    
    public func fetchAll() async -> [LocalNotification] {
        return await store.getPendingRequests()
    }
    
    public func update(for id: String, notification: LocalNotification) async throws {
        // get pending notifications
        var notifications = await fetchAll()
        
        guard let index = notifications.firstIndex(where: {$0.id == id}) else {
            throw Error.updateLocalNotificationFailed
        }
        
        notifications.insert(notification, at: index)
        
        try await create(notifications: notifications)
    }
}
