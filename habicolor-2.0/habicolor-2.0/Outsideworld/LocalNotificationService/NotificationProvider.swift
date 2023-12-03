//
//  NotificationService.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/11/2023.
//

import Foundation
import UserNotifications

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
            info: ["identifier": categoryIdentifier],
            dateComponents: dateComponents
        )
    }

    /// - Parameters:
    ///  - predicate: any kind of identifier where the notification can be find by category
    func findNotifications(_ predicate: String? = nil, completion: @escaping (([UNNotificationRequest]) -> Void)) {
        UNNotificationRequest.findNotifications(completion: completion)
    }
   
    // MARK: UPDATE
    
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
    
    static func findNotifications(predicate: String? = nil, completion: @escaping (([UNNotificationRequest]) -> Void)) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            
            if let predicate {
                
                 let notifications = notifications.filter({$0.content.userInfo["identifier"] as? String == predicate})
                completion(notifications)
                
                return
            }
            
            completion(notifications)
        }
    }
    
    static func removeUNNotification(with identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
