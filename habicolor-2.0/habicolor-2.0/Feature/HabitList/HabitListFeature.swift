//
//  HabitListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import Foundation
import ComposableArchitecture

struct HabitListFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var habits: IdentifiedArrayOf<Habit> = []
        
        init() {
            self.habits = IdentifiedArrayOf(uniqueElements: Habit.staticContent)
        }
    }
    
    enum Action : Equatable {
        case addHabitTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self>  {
        
        Reduce { state, action in
            
            switch action {
            case .addHabitTapped:
                
                state.destination = .addHabitForm(AddHabitFeature.State())
                
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension HabitListFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case addHabitForm(AddHabitFeature.State)
        }
        
        enum Action: Equatable {
            case addHabitForm(AddHabitFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addHabitForm, action: /Action.addHabitForm) {
                AddHabitFeature()
            }
        }
    }
}
