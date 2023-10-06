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
        @PresentationState var destination: Destination.State?
        
        var habits: [Habit]
        
        init(destination: Destination.State? = nil, habits: [Habit]) {
            self.destination = destination
            self.habits = habits
        }
    }
    
    enum Action: Equatable {
        case addHabitLogButtonTapped
        case navigateToHabit(habit: Habit)
        case destination(PresentationAction<Destination.Action>)
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
            case .addHabitLogButtonTapped:
     
                state.destination = .addHabitLog(AddHabitLogFeature.State())
                
                return .none
        
            default:
                return .none
            
            }
        }
    }
}

// MARK: navigation

extension AppFeature {
    
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case addHabitLog(AddHabitLogFeature.State)
        }
        
        enum Action: Equatable {
            case addHabitLog(AddHabitLogFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addHabitLog, action: /Action.addHabitLog) {
                AddHabitLogFeature()
            }
        }
    }
}
