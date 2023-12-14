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
    var day: Int
    var hour: Int
    var minute: Int

    
    // add all date components
    init(title: String, body: String, identifier: String, category: String, days: Int, hour: Int, minute: Int) {
        self.title = title
        self.body = body
        self.identifier = identifier
        self.category = category
        self.day = days
        self.hour = hour
        self.minute = minute
    }
    
    init(request: UNNotificationRequest) {
        self.title = request.content.title
        self.body = request.content.body
        self.identifier = request.identifier
        self.category = request.content.userInfo[NotificationUserInfoKey.categoryIdentifierKey] as? String ?? ""
        
        if let trigger = request.trigger as? UNCalendarNotificationTrigger {
            self.day = trigger.dateComponents.day ?? 0
            self.hour = trigger.dateComponents.hour ?? 0
            self.minute = trigger.dateComponents.minute ?? 0
        } else {
            self.day = 0
            self.hour = 0
            self.minute = 0
        }
    }
}

extension NotificationInfo {
    
    var dateComponents: DateComponents {
        return DateComponents(day: day, hour: hour, minute: minute)
    }
}
