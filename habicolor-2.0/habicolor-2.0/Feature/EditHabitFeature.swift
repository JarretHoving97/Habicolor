//
//  EditHabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 21/10/2023.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct EditHabitFeature: Reducer {
    
    struct State: Equatable {
    
        let habitId: UUID?
        @BindingState var habitName: String
        @BindingState var habitDescription: String
        @BindingState var habitColor: Color
        @BindingState var weekGoal: Int = 1
        
        var notifications: [Notification] = []
        
        let weekgoals = [1, 2, 3, 4, 5, 6, 7]
        
        init(habit: Habit) {
            self.habitId = habit.id
            self.habitName =  habit.name
            self.habitDescription = habit.description
            self.habitColor = habit.color
            self.notifications = habit.notifications
        }
    }
    
    enum Action: BindableAction, Equatable {
        
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
                return .run { [
                    habit = Habit(
                        id: state.habitId ?? UUID(),
                        name: state.habitName,
                        description: state.habitDescription,
                        color: .red,
                        weekHistory: [0, 2, 3],
                        notifications: state.notifications
                    )
                ] send in
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
                
                
            case .removeNotification(let id):
                
                HapticFeedbackManager.impact(style: .soft)
                state.notifications.removeAll(where: {$0.id == id})
                
                return .none
            }
        }
    }
}
