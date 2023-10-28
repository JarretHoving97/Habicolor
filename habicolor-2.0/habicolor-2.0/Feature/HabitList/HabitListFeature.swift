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
        var habits: IdentifiedArrayOf<HabitFeature.State> = []
        
        var completedHabits: IdentifiedArrayOf<HabitFeature.State> = []
      
        init() {
            self.habits = IdentifiedArrayOf(uniqueElements: Habit.staticContent.map({HabitFeature.State(habit: $0)}))
        }
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case addHabitTapped
        case destination(PresentationAction<Destination.Action>)
        case habit(id: UUID, action: HabitFeature.Action)
        case doneHabit(id: UUID, action: HabitFeature.Action)
        case addHabitToDone(HabitFeature.State)
    }
    
    var body: some ReducerOf<Self>  {
        Reduce { state, action in
            
            switch action {
                
            case .addHabitTapped:
                
                state.destination = .addHabitForm(AddHabitFeature.State(habitId: nil))
                
                return .none
                
            
            case let .path(.element(id: _, action: .habitDetail(.delegate(.habitUpdated(habit))))):
                
            
                
//                state.habits.[id: habit.id] = habit

                return .none
                
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                state.habits.append(HabitFeature.State.init(habit: habit))
                
                return .none
                
                
            case .destination:
                return .none
                
            case .path:
                return .none
                
                
            case let .habit(id: _, action: .delegate(.didLogForHabit(habit: habit, emoji: _))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit == habit}) else { return .none}
                let newHabitState = HabitFeature.State.init(habit: habit)

                state.habits.remove(at: index)
                
        
                return .run { [habit = newHabitState] send in
                    
                    await send(.addHabitToDone(habit), animation: .easeIn)
                }
                
            case .addHabitToDone(let newHabitState):
                
                state.completedHabits.append(newHabitState)
                
                return .none
                
            case .habit:
                
                return .none
                
            case .doneHabit(id: _, action: _):
                
                
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        
        .forEach(\.habits, action: /HabitListFeature.Action.habit(id:action:)) {
            HabitFeature()
        }
        
        .forEach(\.completedHabits, action: /HabitListFeature.Action.doneHabit(id:action:)) {
            HabitFeature()
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
