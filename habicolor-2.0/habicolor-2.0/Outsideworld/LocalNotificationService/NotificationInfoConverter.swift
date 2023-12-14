//
//  NotificationInfoConverter.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 14/12/2023.
//

import Foundation


class NotificationInfoConverter {
    
    static func convert(category: UUID, notifications: [Reminder]) -> [NotificationInfo] {
        
        
        var info: [NotificationInfo] = []
        
        notifications.forEach { reminder in
            
            info += reminder.days.map(
                {
                    NotificationInfo(
                        title: reminder.title,
                        body: reminder.description,
                        identifier: reminder.id.uuidString,
                        category: category.uuidString,
                        weekDay: $0.rawValue,
                        hour: reminder.time.get(.hour),
                        minute: reminder.time.get(.minute)
                    )
                }
            )
        }
        
        return info
    }
}
