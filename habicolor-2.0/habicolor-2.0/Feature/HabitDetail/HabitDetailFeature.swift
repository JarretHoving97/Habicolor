//
//  HabitDetailView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import ComposableArchitecture


class HabitDetailFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var habit: Habit
    }
    
    enum Action: Equatable {
        case editHabitTapped(Habit)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case habitUpdated(Habit)
        }
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .editHabitTapped:
                
                state.destination = .edit(
                    AddHabitFeature.State(
                        habitName: state.habit.name,
                        habitDescription: state.habit.description,
                        habitColor: state.habit.color, weekGoal: 4, 
                        habitId: state.habit.id,
                        notifications: state.habit.notifications
                    )
                )
                
                return .none
                
                
            case let .destination(.presented(.edit(.delegate(.editHabit(habit))))):
                
                state.habit = habit
                
                return .none
                
                
            case .destination:
                
                return .none
                
            case .delegate:
                
                return .none
                
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .onChange(of: \.habit) { oldValue, newValue in
            Reduce { state, action in
                    .send(.delegate(.habitUpdated(newValue)))
            }
        }
    }
    
    
    // modal
    struct Destination: Reducer {
        
        enum State: Equatable {
            case edit(AddHabitFeature.State)
        }
        
        enum Action: Equatable {
            case edit(AddHabitFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.edit, action: /Action.edit) {
                AddHabitFeature()
            }
        }
    }
}
