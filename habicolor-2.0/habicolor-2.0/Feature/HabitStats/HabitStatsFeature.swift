//
//  HabitStatsFeaute.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 12/11/2023.
//

import Foundation
import ComposableArchitecture


struct HabitStatsFeature: Reducer {
    
    struct State: Equatable {
        
        private(set) var logs: [HabitLog]
        var averageScore: Float = 0
        var weekGoal: Int
        
        init(logs: [HabitLog], weekgoal: Int) {
            self.logs = logs
            self.weekGoal = weekgoal
        }
    }
    
    enum Action {
        // average score
        case calculateAverageScore
        
        // calculate days missed
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
            }
        }
    }
}
