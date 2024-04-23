//
//  ReminderMapper.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 21/04/2024.
//

import Foundation


class ReminderMapper {
    
    
    private init() {}
    
    static func reduce(_ notifications: [LocalNotification]) -> [Reminder] {
        
        var dict = [String: Reminder]()
        
        for notification in notifications {
            let key = notification.title
            if dict[key] == nil {
                dict[key] = Reminder(
                    id: UUID(),
                    days: [WeekDay(rawValue: notification.dateComponents.weekday ?? 0) ?? .sunday],
                    time: notification.dateComponents.date ?? Date(), // Use the date from date components, or default to current date
                    title: notification.title,
                    description: notification.subtitle)
            } else {
                dict[key]?.days.append(WeekDay(rawValue: notification.dateComponents.weekday ?? 0) ?? .sunday)
            }
        }
        
        return Array(dict.values)
    }
}
