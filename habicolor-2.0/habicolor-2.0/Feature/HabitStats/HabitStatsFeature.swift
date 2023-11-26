//
//  HabitStatsFeaute.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI


struct HabitStatsFeature: Reducer {
    
    struct State: Equatable {
        
        private(set) var logs: [HabitLog]
        var weeksWhereCouldRegistered: [[Date]] = []
        var missed: Int = 0
        var color: Color
        var averageScore: Float = 0
        var weekGoal: Int
        
        init(logs: [HabitLog], weekgoal: Int, color: Color) {
            self.logs = logs
            self.weekGoal = weekgoal
            self.color = color
        }
    }
    
    enum Action {
        // average score
        case calculateAverageScore
        
        // calculate days missed
        case scanMissedRegistrations
        
        // show missed days
        case configuredMissedDaysForWeekGoal
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
                
            case .calculateAverageScore:
                
                var score: Int = 0
                
                let scores = state.logs.map { $0.emoji.rawValue }
                scores.forEach { logScore in
                    score += logScore
                }
                
                if score == 0 { return .none }
                let averageScore = Float(score / scores.count)
                let result = averageScore / 5 // 5 = 100%
                
                state.averageScore = result * 10
                
                return .none
                
            case .scanMissedRegistrations:
                
                guard let startOfWeekCurrentWeek = MyCalendar.shared.calendar.date(byAdding: .weekOfYear, value: 1, to: Date().startOfWeek) else { return .none }
                
                var lastRegitration = state.logs.last?.logDate ?? Date()
                
                while lastRegitration < startOfWeekCurrentWeek.startOfWeek {
                    
                    var weekToAppend: [Date] = []
                    
                    (1...7).forEach { day in
                        if let weekDay =  MyCalendar.shared.calendar.date(byAdding: .day, value: 1, to: lastRegitration) {
                            lastRegitration = weekDay
                            weekToAppend.append(lastRegitration)
                        }
                    }
                    state.weeksWhereCouldRegistered.append(weekToAppend)
                }
                
                return .run { send in
                    await send(.configuredMissedDaysForWeekGoal)
                }
                
            case .configuredMissedDaysForWeekGoal:
                
                let registerDates = state.logs.map({MyCalendar.shared.calendar.startOfDay(for: $0.logDate)})
                
                guard !registerDates.isEmpty else { return .none }
                
                state.weeksWhereCouldRegistered.forEach { week in
                    
                    var weeklyRegisterCount: Int = 0
                    
                    for day in week {
                        let clearDate = MyCalendar.shared.calendar.startOfDay(for: day)
                        
                        if registerDates.contains(clearDate) {
                            weeklyRegisterCount += 1
                        }
                        
                        state.missed += state.weekGoal - min(weeklyRegisterCount, state.weekGoal)
                    }
                }
            }
            
            return .none
            
        }
    }
}
