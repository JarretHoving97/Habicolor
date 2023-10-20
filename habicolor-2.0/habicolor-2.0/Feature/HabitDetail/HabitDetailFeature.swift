//
//  HabitDetailView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import ComposableArchitecture


class HabitDetailFeature: Reducer {
    
    struct State: Equatable {
        var habit: Habit
    }
    
    enum Action: Equatable {
//        case deleteHabitPressed
//        case editHabitPressed
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            return .none
        }
    }
}
