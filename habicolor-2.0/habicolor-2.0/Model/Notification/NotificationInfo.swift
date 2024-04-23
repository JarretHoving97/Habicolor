//
//  NotificationInfo.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/11/2023.
//

import Foundation
import NotificationCenter


struct NotificationInfo: Hashable, Equatable {
    
    var identifier: String
    var category: String
    var title: String
    var body: String
    var weekDay: Int
    var hour: Int
    var minute: Int

    
    // add all date components
    init(title: String, body: String, identifier: String, category: String, weekDay: Int, hour: Int, minute: Int) {
        self.title = title
        self.body = body
        self.identifier = identifier
        self.category = category
        self.weekDay = weekDay
        self.hour = hour
        self.minute = minute
    }
    
    init(request: UNNotificationRequest) {
        self.title = request.content.title
        self.body = request.content.body
        self.identifier = request.identifier
        self.category = request.content.userInfo[NotificationUserInfoKey.categoryIdentifierKey] as? String ?? ""
        
        if let trigger = request.trigger as? UNCalendarNotificationTrigger {
            self.weekDay = trigger.dateComponents.weekday ?? 0
            self.hour = trigger.dateComponents.hour ?? 0
            self.minute = trigger.dateComponents.minute ?? 0
        } else {
            self.weekDay = 0
            self.hour = 0
            self.minute = 0
        }
    }
}

extension NotificationInfo {
    
    var dateComponents: DateComponents {
        return DateComponents(hour: hour, minute: minute, weekday: weekDay)
    }
}


class LocalNotificationMapper {
    
    static func map(info: NotificationInfo) -> LocalNotification {
        return LocalNotification(
            id: info.identifier,
            title: info.title,
            subtitle: info.body,
            sound: .default,
            userInfo: ["category": info.category],
            dateComponents: info.dateComponents,
            repeats: true
        )
    }
}
