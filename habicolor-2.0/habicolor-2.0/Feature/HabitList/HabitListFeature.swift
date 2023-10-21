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
        
        var path = StackState<Path.State>()
        var habits: IdentifiedArrayOf<Habit> = []
      
        init() {
            self.habits = IdentifiedArrayOf(uniqueElements: Habit.staticContent)
        }
    }
    
    enum Action : Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case addHabitTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self>  {
        Reduce { state, action in
            
            switch action {
                
            case .addHabitTapped:
                
                state.destination = .addHabitForm(AddHabitFeature.State(habitId: nil))
                
                return .none
                
            
            case let .path(.element(id: _, action: .habitDetail(.delegate(.habitUpdated(habit))))):
                
                
                state.habits[id: habit.id] = habit

                return .none
                
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                
                state.habits.append(habit)
                
                return .none
                
                
            case .destination:
                return .none
                
            case .path:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

// MARK: Destination
extension HabitListFeature {
    
    // modal
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
    
    
    // navigation stack
    struct Path: Reducer {
        
        enum State: Equatable {
            case habitDetail(HabitDetailFeature.State)
        }
        
        enum Action: Equatable {
            case habitDetail(HabitDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.habitDetail, action: /Action.habitDetail) {
                HabitDetailFeature()
            }
        }
    }
}
