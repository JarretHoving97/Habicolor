//
//  LocalNotificationManager.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/04/2024.
//

import Foundation
import NotificationCenter

public protocol NotificationManager {
    func addNotification(_ notification: LocalNotification) async throws
    func getPendingRequests() async -> [LocalNotification]
    func removePendingRequests(with identifiers: [String])
}

public class AppLocalNotificationManager {
    
    private let notificationCenter: UNUserNotificationCenter
    
    public init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }
}

extension AppLocalNotificationManager: NotificationManager {
    
    public func addNotification(_ notification: LocalNotification) async throws {
        try await notificationCenter.add(notification.toNotificationRequest())
    }
    
    public func getPendingRequests() async -> [LocalNotification] {
        return await notificationCenter.pendingNotificationRequests().map { $0.toModel() }
    }
    
    public func removePendingRequests(with identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

