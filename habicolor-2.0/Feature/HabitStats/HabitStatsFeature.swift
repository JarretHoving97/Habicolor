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
    
    let client: LogClient

    struct State: Equatable {
    
        var color: Color
        var averageScore: Int = 0
        var completionRate: Double = 0.0
        var weekGoal: Int
        let habit: UUID
        
        init(weekgoal: Int, color: Color, habit: UUID) {
            self.weekGoal = weekgoal
            self.color = color
            self.habit = habit
        }
        
        init(habit: Habit) {
            self.weekGoal = habit.weekGoal
            self.color = habit.color
            self.habit = habit.id
        }
    }
    
    enum Action {
        case loadWeeksCompletionRate
        case loadWeeksAverageScore
        
        case loadExampleScore
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
                
            case .loadWeeksCompletionRate:
            
                let result = client.findInBetween(state.habit, Date().startOfWeek, Date().endOfWeek).data ?? []
                
                guard result.count != 0  else {
                    state.completionRate = 0
                    
                    return .none
                }
                
                let calc =  Double(result.count) / Double(state.weekGoal) * 100
      
                state.completionRate = calc.rounded() / 100
                
                return .none
                
            case .loadWeeksAverageScore:
                
                let result = client.findInBetween(state.habit, Date().startOfWeek, Date().endOfWeek).data ?? []
                
                guard result.count != 0 else { return .none }
                
                let scores = result.map({$0.score})
                
                let sum = scores.reduce(0, +)
            
                state.averageScore = sum / scores.count

                return .none
                
            case .loadExampleScore:
                
                state.completionRate = 1
                state.averageScore = 4
                
                return .none
            }
        }
    }
}
