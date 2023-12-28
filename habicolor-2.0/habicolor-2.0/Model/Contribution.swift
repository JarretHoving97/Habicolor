//
//  Contribution.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/11/2023.
//

import Foundation

struct Contribution: Hashable {
    let log: HabitLog?
    let date: Date
}


extension Contribution {
    
    static func generateAWholeYear() -> [[Contribution]] {
        
        
        let calendar = MyCalendar.shared.calendar
        
        let today = Date().startOfDay
        let startOfWeek = today.startOfWeek

        
        let monthsBack = calendar.date(byAdding: .month, value: -12, to: startOfWeek)!
    
        
        var startOfWeekMonthsBack = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthsBack))!
        
    
        var previousWeeks: [[Contribution]] = []
        
        while startOfWeekMonthsBack < today {
          
            var weekToAppend: [Contribution] = []

            (1...7).forEach { day in
                if let weekday = calendar.date(byAdding: .day, value: 1, to: startOfWeekMonthsBack) {
                    
                    // find log for this date
                    
                    startOfWeekMonthsBack = weekday
                    weekToAppend.append(Contribution(log: .random(for: weekday), date: weekday))
                }
            }
            previousWeeks.append(weekToAppend)
        }
        
        return previousWeeks
      }
}
