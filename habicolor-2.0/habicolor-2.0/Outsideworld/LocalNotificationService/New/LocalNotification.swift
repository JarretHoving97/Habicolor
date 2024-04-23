//
//  LocalNotification.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/04/2024.
//

import Foundation
import NotificationCenter

public struct LocalNotification {
    
    public let id: String
    public var title: String
    public var subtitle: String
    public var sound: UNNotificationSound?
    public var userInfo: [AnyHashable: Any]
    public var dateComponents: DateComponents
    public var repeats: Bool
    
    public init(id: String, title: String, subtitle: String, sound: UNNotificationSound?, userInfo: [AnyHashable : Any], dateComponents: DateComponents, repeats: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.sound = sound
        self.userInfo = userInfo
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
}

public extension LocalNotification {
    
    func toNotificationRequest() -> UNNotificationRequest {
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        content.userInfo = userInfo
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        return request
    }
}

public extension UNNotificationRequest {
    
    func toModel() -> LocalNotification {
        
        return LocalNotification(
            id: identifier,
            title: content.title,
            subtitle: content.subtitle,
            sound: content.sound,
            userInfo: content.userInfo,
            dateComponents: (trigger as! UNCalendarNotificationTrigger).dateComponents,
            repeats: trigger?.repeats ?? true
        )
    }
}
