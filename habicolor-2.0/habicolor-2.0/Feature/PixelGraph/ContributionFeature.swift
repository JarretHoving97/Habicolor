//
//  ContributionFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/11/2023.
//

import Foundation
import ComposableArchitecture

struct ContributionFeature: Reducer {

    struct State: Equatable {
        let logs: [HabitLog]
        var selection: MonthSelection = .twelve
        var currentWeek: [Date] = []
        var previousWeeks: [[Date]] = []
        
        enum MonthSelection: Int {
            case three = 3
            case six = 6
            case twelve = 12
        }
    }
    
    enum Action {
        case generateCurrentWeek
        case generatePreviousWeeks
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .generatePreviousWeeks:
                
                let calendar = MyCalendar.shared.calendar
                
                let today = calendar.startOfDay(for: Date())
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
                
                let monthsBack = calendar.date(byAdding: .month, value: -state.selection.rawValue, to: startOfWeek)!
            
                
                var startOfWeekMonthsBack = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthsBack))!
                
                
                while startOfWeekMonthsBack < today {
                  
                    var weekToAppend: [Date] = []

                    (1...7).forEach { day in
                        if let weekday = calendar.date(byAdding: .day, value: 1, to: startOfWeekMonthsBack) {
                            startOfWeekMonthsBack = weekday
                            weekToAppend.append(startOfWeekMonthsBack)
                        }
                    }

                    state.previousWeeks.append(weekToAppend)
                }
                
            case .generateCurrentWeek:
                let calendar = MyCalendar.shared.calendar
                
                let today = calendar.startOfDay(for: Date())
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                
                (1...7).forEach { day in
                    if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                        state.currentWeek.append(weekday)
                    }
                }
            }
            
            return .none
        }
        
    }
    
}
