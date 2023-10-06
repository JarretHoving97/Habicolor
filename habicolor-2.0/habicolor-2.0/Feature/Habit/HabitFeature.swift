//
//  HabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture

struct HabitFeature: Reducer {
    
    struct State: Equatable {
        var habit: Habit

    }
    
    enum Action {
        case showDetail
        case logForHabit
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
            case .logForHabit:
                
                print("Logged for: \(state.habit.name)")
                
                return .none
                
            case .showDetail:
                
                print("show detail for: \(state.habit.name)")
                
                return .none
            }
            
        }
    }

}
