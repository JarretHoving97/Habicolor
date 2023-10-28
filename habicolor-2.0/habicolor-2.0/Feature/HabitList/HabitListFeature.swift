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
        let value: String = ""
        
        
        init() {
            self.habits = IdentifiedArrayOf(uniqueElements: Habit.staticContent.map({HabitFeature.State(habit: $0)}))
        }
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case setDone(HabitFeature.State)
        case addHabitTapped
        case habit(id: UUID, action: HabitFeature.Action)
        case showDetail(Habit)
    }
    
    var body: some ReducerOf<Self>  {
        Reduce { state, action in
            
            switch action {
                
            case .addHabitTapped:
                
                state.destination = .addHabitForm(AddHabitFeature.State(habitId: nil))
                
                return .none
                
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.habitUpdated(habit))))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none}
                
                state.habits[index].habit = habit
                
                
                return .none
                
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                state.habits.append(HabitFeature.State.init(habit: habit))
                
                return .none
                
                
            case let .habit(id: _, action: .delegate(.didLogForHabit(habit: habit, emoji: _))):
                
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none}
            
                var newHabitState = state.habits[index]
                newHabitState.habit = habit
                state.habits.remove(at: index)
        
            
                return .run { [newHabitState] send in
                    await send(.setDone(newHabitState), animation: .easeIn)
                }
                
                
            case .setDone(let habitState):
                var value = habitState
                value.showAsCompleted = true // show faded out
                state.habits.append(value)
                return .none
                
                
            case let .habit(id: _, action: .delegate(.didTapSelf(habit))):
                
                
                return .run {[habit] send in
                    
                    await send(.showDetail(habit))
                }
                
                
            case .showDetail(let habit):
                
                state.path.append(HabitListFeature.Path.State.habitDetail(HabitDetailFeature.State(habit: habit)))
                
                return .none

            case .habit:
                
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
        
        .forEach(\.habits, action: /HabitListFeature.Action.habit(id:action:)) {
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
