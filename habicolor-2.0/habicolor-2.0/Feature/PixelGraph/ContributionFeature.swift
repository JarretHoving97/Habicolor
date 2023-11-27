//
//  ContributionFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/11/2023.
//

import Foundation
import ComposableArchitecture

struct ContributionFeature: Reducer {
    
    let client: LogClient

    struct State: Equatable {
        let habit: UUID
        var selection: MonthSelection = .twelve
        var currentWeek: [Contribution] = []
        var previousWeeks: [[Contribution]] = []
        
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
                
            
                var previousWeeks: [[Contribution]] = []
                
                while startOfWeekMonthsBack < today {
                  
                    var weekToAppend: [Contribution] = []

                    (1...7).forEach { day in
                        if let weekday = calendar.date(byAdding: .day, value: 1, to: startOfWeekMonthsBack) {
                            
                            // find log for this date
                            
                            startOfWeekMonthsBack = weekday
                            weekToAppend.append(Contribution(log: client.find(state.habit, weekday).data, date: weekday))
                        }
                    }
                    previousWeeks.append(weekToAppend)
                }
                
                state.previousWeeks = previousWeeks
                
                return .none
                
            case .generateCurrentWeek:
                let calendar = MyCalendar.shared.calendar
                
                let today = calendar.startOfDay(for: Date())
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                
                var currentWeek: [Contribution] = []
                
                (1...7).forEach { day in
                    if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                        currentWeek.append(Contribution(log: client.find(state.habit, weekday).data, date: weekday))
                    }
                }
                
                state.currentWeek = currentWeek
            }
    
            return .none
        }
        
    }
    
}
