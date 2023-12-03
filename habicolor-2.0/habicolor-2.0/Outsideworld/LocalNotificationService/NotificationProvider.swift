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
    
    /// - Parameters:
    ///    - categoryIdentifier: Key name where you can find local notifications by this identifier
    ///    - title: Notification title to show to the user
    ///    - Message: Notification content to show
    ///    - dateComponents: Components  to give in when the user needs to be identified
    func create(for categoryIdentifier: String, title: String, message: String, dateComponents: DateComponents, repeats: Bool = true) -> UNNotificationRequest {
        .create(
            title: title,
            message: message,
            info: [ NotificationUserInfoKey.categoryIdentifierKey: categoryIdentifier],
            dateComponents: dateComponents
        )
    }

    /// - Parameters:
    ///  - predicate: any kind of identifier where the notification can be find by category
    func findNotifications(_ predicate: String? = nil, completion: @escaping (([UNNotificationRequest]) -> Void)) {
        UNNotificationRequest.findBy(predicate: predicate, completion: completion)
    }
   
    // MARK: UPDATE
    func updateNotification(_ id: String, title: String, message: String, dateComponents: DateComponents) -> UNNotificationRequest {
        
        var notification: UNNotificationRequest?
        
        UNNotificationRequest.find(id: id) { [unowned self] results in
            notification = results.first
            self.removeLocalNotifications(for: results.map({$0.identifier}))
        }
        
        return notification ?? create(for: UUID().uuidString, title: title, message: message, dateComponents: dateComponents)
    }
    
    // MARK: DELETE
    func removeLocalNotifications(for identifiers: [String]) {
        UNNotificationRequest.removeUNNotification(with: identifiers)
    }
}


extension UNNotificationRequest {
    
    /// Adds request in system, returns the created notification
    static func create(title: String, message: String, info: [String: String], dateComponents: DateComponents, repeats: Bool = true) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message
        content.sound = UNNotificationSound.default
        content.userInfo = info
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        return request
    }
    
    static func findBy(predicate: String?, completion: @escaping (([UNNotificationRequest]) -> Void)) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            
            if let predicate {
                
                 let notifications = notifications.filter({$0.content.userInfo[NotificationUserInfoKey.categoryIdentifierKey] as? String == predicate})
                completion(notifications)
                
                return
            }
            
            completion(notifications)
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
