//
//  AppFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture


struct AppFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case addHabitLogButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        
        
        Reduce { state, action in
            
            switch action {
            case .addHabitLogButtonTapped:
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

// MARK: NavigationStack
extension AppFeature {
    
    
    struct Path: Reducer {
        
        enum State: Equatable {
            case habitDetail(HabitDetailFeature.State)
            case addHabit(AddHabitFeature.State)
        }
        
        enum Action: Equatable {
            case habitDetail(HabitDetailFeature.Action)
            case addHabit(AddHabitFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.habitDetail, action: /Action.habitDetail) {
                HabitDetailFeature()
            }
            
            Scope(state: /State.addHabit, action: /Action.addHabit) {
                AddHabitFeature()
            }
        }
    }

}
