//
//  Notification.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import Foundation

struct Reminder: Equatable, Hashable {
    
    let id: UUID
    var days: [WeekDay]
    var time: Date
    var title: String
    var description: String
    
    init(id: UUID, days: [WeekDay], time: Date, title: String, description: String) {
        self.id = id
        self.days = days
        self.time = time
        self.title = title
        self.description = description
    }
    
    init(_ nsNotification: NSReminder) {
        self.id = nsNotification.id!
        self.time = nsNotification.time!
        self.title = nsNotification.title!
        self.description = nsNotification.message!
        
        if let daysArray = nsNotification.days as? [Int] {
            // Assuming WeekDay is an enum with a raw value of Int
            self.days = daysArray.compactMap { WeekDay(rawValue: $0) }
        } else {
            self.days = []
        }
    }
}

extension Reminder {
    
    var weekDaysString: String {
        
        return days.map({$0.localizedString.prefix(3)}).joined(separator: ", ").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
