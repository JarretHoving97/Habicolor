//
//  AddHabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct AddHabitFeature: Reducer {
    
    struct State: Equatable {
        
        var path = StackState<Path.State>()
        
        @BindingState var habitName: String = ""
        @BindingState var habitDescription: String = ""
        @BindingState var habitColor: Color = .red
        @BindingState var weekGoal: Int = 1
        
        var notifications: [Notification] = []
        
        let weekgoals = [1, 2, 3, 4, 5, 6, 7]
    }
    
    enum Action: BindableAction, Equatable {
        
        case path(StackAction<Path.State, Path.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case removeNotification(UUID)
        case saveButtonTapped
        case cancelTapped
        
        enum Delegate: Equatable {
            case saveHabit(Habit)
        }
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        
        Reduce { state, action in
            
            
            switch action {
            case .saveButtonTapped:
                return .run { [habit = Habit(name: state.habitName, description: state.habitDescription, color: .red, weekHistory: [0, 2, 3])] send in
                    await send(.delegate(.saveHabit(habit)))
                    await dismiss()
                    
                }
                
            case .cancelTapped:
                
                return .run { send in
                    await dismiss()
                }
                
            case .binding(_):
                return .none
                
            case .delegate(_):
                return .none
                
                
            case let .path(.element(id: _, action: .addNotification(.delegate(.addNotification(notification))))):
            
                state.notifications.append(notification)
                
                return .none
                
            case .removeNotification(let id):
                
                HapticFeedbackManager.impact(style: .soft)
                state.notifications.removeAll(where: {$0.id == id})
                
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

// MARK: NAVIGATION STACK
extension AddHabitFeature {
    
    
    struct Path: Reducer {
        
        enum State: Equatable {
            case addNotification(AddNotificationFeature.State)
        }
        
        enum Action: Equatable {
            case addNotification(AddNotificationFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addNotification, action: /Action.addNotification) {
                AddNotificationFeature()
            }
        }
    }
}
