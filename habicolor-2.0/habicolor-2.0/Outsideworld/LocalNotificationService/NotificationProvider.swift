//
//  NotificationService.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/11/2023.
//

import Foundation
import UserNotifications

class NotificationUserInfoKey {
    
    /// a key used to find a local notification on userInfo
    static var categoryIdentifierKey: String { "habicolor.category.identiier.key" }
}


class NotificationProvider {
    
    static var shared = NotificationProvider()
    
    /// - Parameters:
    ///    - categoryIdentifier: Key name where you can find local notifications by this identifier
    ///    - title: Notification title to show to the user
    ///    - Message: Notification content to show
    ///    - dateComponents: Components  to give in when the user needs to be identified
    func create(for reminderId: String, title: String, message: String, dateComponents: DateComponents,  info: [String: String], repeats: Bool = true) async {
        
        await LocalNotificationHelper.create(
            id: reminderId,
            title: title,
            body: message,
            sound: .default,
            components: dateComponents,
            info: info
        )
    }
    
    /// - Parameters:
    ///  - predicate: any kind of identifier where the notification can be find by category
    func findNotifications(_ predicate: String? = nil) async -> [NotificationInfo] {
        let result = try? await UNNotificationRequest.findBy(predicate: predicate).map( { NotificationInfo(request: $0)} )
        return result ?? []
    }
    
    // MARK: DELETE
    func removeLocalNotifications(for identifiers: [String]) {
        UNNotificationRequest.removeUNNotification(with: identifiers)
    }
}


extension UNNotificationRequest {
    
    /// Adds request in system, returns the created notification
    static func create(title: String, message: String, info: [String: String], dateComponents: DateComponents, repeats: Bool = true) async -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message
        content.sound = UNNotificationSound.default
        content.userInfo = info
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        try? await UNUserNotificationCenter.current().add(request)
        
        return request
    }
    
    
    static func findBy(predicate: String?) async throws -> [UNNotificationRequest] {
        return try await withCheckedThrowingContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
                
                if let predicate = predicate {
                    let filteredNotifications = notifications.filter {
                        $0.content.userInfo[NotificationUserInfoKey.categoryIdentifierKey] as? String == predicate
                    }
                    continuation.resume(returning: filteredNotifications)
                } else {
                    continuation.resume(returning: notifications)
                }
            }
        }
    }
    
    
    
    static func find(id: String, completion: @escaping (([UNNotificationRequest]) -> Void)) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            let result = notifications.filter({$0.identifier == id})
            completion(result)
        }
    }
    
    static func removeUNNotification(with identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}


class LocalNotificationHelper {
    
    static func create(id: String, title: String, body: String, sound: UNNotificationSound, components: DateComponents, info: [String: String]) async {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.userInfo = info
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            Log.debug("did add notification for: \(components.description)")
        } catch {
            Log.error(String(describing: error))
        }
    }
}
