//
//  AddNotificationFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/10/2023.
//


import Foundation
import ComposableArchitecture
import NotificationCenter

class AddNotificationFeature: Reducer {
    
    let notificationHelper = NotificationPermissions()
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        
        @BindingState var time = Date()
        @BindingState var notificationMessage: String = ""
        @BindingState var notificationTitle: String = ""
        
        
        var selectWeekDays = SelectWeekDaysFeature.State(selectedWeekDays: WeekDay.allCases)
        
        @BindingState var field: Field?
        
        enum Field: Hashable {
            case titleField
            case descriptionField
        }
    }
    
    enum Action: BindableAction, Equatable {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case addNotification
        case selectWeekDays(SelectWeekDaysFeature.Action)
        
        case showFieldErrors([State.Field])
        case showInvalidNoticationDays
    }
    
    enum Delegate: Equatable {
        case addNotification(Reminder)
        case userNotAllowedNotifications
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.selectWeekDays, action: /Action.selectWeekDays) {
            SelectWeekDaysFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .addNotification:
                
                return .run { [self, notification = Reminder(id: UUID(), days: state.selectWeekDays.selectedWeekDays, time: state.time, title: state.notificationTitle, description: state.notificationMessage)] send in
                    
                    // field validation
                    var invalidFields: [State.Field] = []
                    
                    // check for notification title
                    if notification.title.trimmingCharacters(in: .whitespaces).isEmpty {
                        invalidFields.append(.titleField)
                    }
                    
                    // check description
                    if notification.description.trimmingCharacters(in: .whitespaces).isEmpty {
                        invalidFields.append(.descriptionField)
                    }
                    
                    guard invalidFields.isEmpty else {
                        HapticFeedbackManager.notification(type: .error)
                        await send(.showFieldErrors(invalidFields))
                        return
                    }
                    
                    // check if there are any weekdays selected
                    guard !notification.days.isEmpty else {
                        HapticFeedbackManager.notification(type: .error)
                        await send(.showInvalidNoticationDays)
                        
                        return
                    }
                    
                    let _ = await notificationHelper.askUserToAllowNotifications() // ask for permission only
                    
                    await send(.delegate(.addNotification(notification)))
                    
                    await self.dismiss()
                    
                }
                
            case .binding(_):
                
                return .none
                
            case .delegate(_):
                return .none
                
            case .selectWeekDays:
                
                return .none
                
            case .destination(.presented(.alert(.understoodPressed))):
                
                state.destination = nil
                
                return .none
                
            case .destination:
                
                return .none
                
            case .showFieldErrors(let fields):
                
                var errorDescription: String = ""
                
                if fields.count > 1 {
                    errorDescription = "Your notification must contain a title and a message."
                } else if let field = fields.first {
                    
                    switch field {
                    case .titleField:
                        errorDescription = "Your notification needs a title!"
                    case .descriptionField:
                        errorDescription = "Your notification needs a message!"
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
                
            case .showInvalidNoticationDays:
                
                state.destination = .alert(.noNotificationDaysSelected)
                
                return .none
                
            }
        }
    }
}

// MARK: Presentations
extension AddNotificationFeature {
    
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

// MARK: Alert for not selecting weekdays
extension AlertState where Action == AddNotificationFeature.Destination.Action.Alert {
    
    static let noNotificationDaysSelected = Self {
        
        TextState("Please select any weekday to get notified.")
        
    } actions: {
        ButtonState(role: .cancel, action: .understoodPressed) {
            TextState("Ok")
        }
    }
}

