//
//  AddHabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct AddHabitFeature: Reducer {
    
    let notificationsClient: ReminderClient = .live
    
    struct State: Equatable {
        
        @PresentationState var destination: Destination.State?
        @BindingState var focus: Field?
        @BindingState var habitName: String = ""
        @BindingState var habitDescription: String = ""
        @BindingState var habitColor: Color = .primaryColor
        @BindingState var weekGoal: Int = 1
        
        var path = StackState<Path.State>()
        let habitId: UUID?
        var notifications: [Reminder] = []
        let weekgoals = [1, 2, 3, 4, 5, 6, 7]
        
        enum Field: Hashable {
            case habitName
            case habitMotivation
        }
    }
    
    enum Action: BindableAction, Equatable {
        
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case removeNotification(UUID)
        case addNotificationTapped
        case saveButtonTapped
        case editButtonTapped
        case cancelTapped
        case loadReminders
        
        case showFieldErrors([State.Field])
        
        enum Delegate: Equatable {
            case saveHabit(Habit)
            case editHabit(Habit)
            case showDoesNotAllowNotifications
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
                        weekGoal: state.weekGoal,
                        description: state.habitDescription,
                        color: state.habitColor,
                        notifications: state.notifications
                    )
                ] send in
                    
                    // field validation
                    var invalidFields: [State.Field] = []
                    
                    // check for name
                    if habit.name.trimmingCharacters(in: .whitespaces).isEmpty {
                        invalidFields.append(.habitName)
                    }
                    
                    // check for habit userdescription
                    if habit.description.trimmingCharacters(in: .whitespaces).isEmpty {
                        invalidFields.append(.habitMotivation)
                    }
                    
                    // check if fiels are empty, else send show error
                    guard invalidFields.isEmpty else {
                        HapticFeedbackManager.notification(type: .error)
                        await send(.showFieldErrors(invalidFields))
                        return
                    }
                    HapticFeedbackManager.notification(type: .success)
                    await send(.delegate(.saveHabit(habit)))
                    await dismiss()
                }
                
            case .editButtonTapped:
                
                if let id = state.habitId {
                    
                    // delete all first
                    notificationsClient.delete(id)
                    
                    // save notifications
                    state.notifications.forEach { notification in
                        
                        let _ = notificationsClient.add(id, notification)
                    }
                }
                
                return .run { [
                    habit = Habit(
                        id: state.habitId ?? UUID(),
                        name: state.habitName,
                        weekGoal: state.weekGoal,
                        description: state.habitDescription,
                        color: state.habitColor,
                        notifications: state.notifications
                    )
                ] send in
                    await send(.delegate(.editHabit(habit)))
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
                
            case .path(.element(id: _, action: .addNotification(.delegate(.userNotAllowedNotifications)))):
                
                return .run { send in
                    await send(.delegate(.showDoesNotAllowNotifications))
                }
                
            case .removeNotification(let id):
                
                HapticFeedbackManager.impact(style: .soft)
                state.notifications.removeAll(where: {$0.id == id})
                
                return .none
                
            case .path:
                return .none
                
            case .loadReminders:
                
                guard let id = state.habitId, state.notifications.isEmpty else { return .none }
                
                let notifications = notificationsClient.all(id).data
                
                state.notifications = notifications ?? []
                
                return .none
                
                
            case .showFieldErrors(let fields):
                
                var errorDescription: String = ""
                
                if fields.count > 1 {
                    errorDescription = "Your habit needs a name and some kind of a description." // TODO: Translations
                    
                } else if let field = fields.first {
                    switch field {
                    case .habitName:
                        errorDescription = "Your habit needs a name"
                        
                    case .habitMotivation:
                        errorDescription = "Your habit needs a motivation or description."
                    }
                }
                
                state.destination = .alert(
                    AlertState { TextState(errorDescription)
                    } actions: {
                        ButtonState(role: .cancel, action: .understoodPressed) {
                            TextState("Ok")
                        }
                    }
                )
                
                return .none
                
            case .destination(.presented(.alert(.understoodPressed))):
                
                state.destination = nil
                
                return .none
                
            case .destination:
                return .none
                
            case .addNotificationTapped:
                
                state.path.append(AddHabitFeature.Path.State.addNotification(.init(notificationTitle: state.habitName)))
                
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


// MARK: Presentation
extension AddHabitFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        enum Action: Equatable {
            
            case alert(Alert)
            
            
            enum Alert {
                case understoodPressed
            }
        }
        
        var body: some ReducerOf<Self> {
            
            Reduce { state, action in
                return .none
            }
        }
    }
}
