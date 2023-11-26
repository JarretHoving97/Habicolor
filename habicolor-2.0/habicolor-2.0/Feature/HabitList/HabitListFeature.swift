//
//  HabitListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import Foundation
import ComposableArchitecture

struct HabitListFeature: Reducer {
    
    var client: HabitClient
    
    struct State: Equatable {
        
        @PresentationState var destination: Destination.State?
        var path = StackState<Path.State>()
        var habits: IdentifiedArrayOf<HabitFeature.State> = []
        let value: String = ""
        
        
        init(habits: [Habit]) {
            self.habits = IdentifiedArray(uniqueElements: habits.map({HabitFeature.State(habit: $0)}))
        }
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case setDone(index: Int)
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
            
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none }
                
                let id = state.habits[index].habit.id
                
                if let updatedHabit = client.updateHabit(habit, id).data {
                    
                    state.habits[index].habit = updatedHabit
                }
                
                return .none
                
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                if let habit = client.add(habit).data {
                    
                    state.habits.insert(HabitFeature.State.init(habit: habit), at: 0)
                }
                
                return .none
                
                
            case let .habit(id: _, action: .delegate(.didLogForHabit(habit: habit, emoji: _))):
                
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none}
                
                if index < state.habits.count {
                    var habitToReplace = state.habits[index]
                    habitToReplace.habit = habit
                    state.habits.remove(at: index)
                    state.habits.append(habitToReplace)
                }
                
        
                return .run { [index] send in
                    await send(.setDone(index: index), animation: .easeIn)
                }
                
                
            case .setDone:
                
                state.habits[state.habits.count - 1].showAsCompleted = true
                
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
            HabitFeature(client: .live)
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
                HabitDetailFeature(habitLogClient: .live)
            }
        }
    }
}
