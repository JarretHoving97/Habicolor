//
//  HabitLog.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import Foundation
import SwiftUI

struct HabitLog: Equatable, Hashable {
    let id: UUID
    var score: Int
    var logDate: Date
}

// MARK: Variables used to show
extension HabitLog {
    
    var emoji: Emoji {
        return Emoji(rawValue: score) ?? .neutral
    }
    
    func color(_ color: Color) -> Color {
        return color.opacity(.alpha(for: emoji))
    }
}

// MARK: STATIC DATA
extension HabitLog {
    
    /// create a random habitLog
    static func random(for date: Date) -> HabitLog {
        return HabitLog(
            id: UUID(),
            score: Int(arc4random_uniform(5)) + 1,
            logDate: date
        )
    }
    
   static func generateYear() -> [HabitLog] {
        var yearBackFromNow = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
       
        var logs: [HabitLog] = []
        
        while yearBackFromNow < Date() {
            if yearBackFromNow.getTodayWeekDay(format: .currentMonthDayNumber) != "12" {
                
                let log = HabitLog.random(for: yearBackFromNow)
                logs.append(log)
            }
            yearBackFromNow = yearBackFromNow.adding(1, .day)!
        }
       
       return logs
    }
}
