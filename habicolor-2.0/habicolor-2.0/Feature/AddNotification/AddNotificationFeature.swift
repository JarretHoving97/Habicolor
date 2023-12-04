//
//  AddNotificationFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/10/2023.
//

import Foundation
import ComposableArchitecture

struct AddNotificationFeature: Reducer {
    
    let notificationHelper = NotificationPermissions()
    
    struct State: Equatable {
        @BindingState var time = Date()
        @BindingState var notificationMessage: String = ""
        @BindingState var notificationTitle: String = ""
        var selectWeekDays = SelectWeekDaysFeature.State(selectedWeekDays: [])
    }
    
    enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case userNotAllowedNotifications
        case addNotificationIfAllowed
        case selectWeekDays(SelectWeekDaysFeature.Action)
    }
    
    enum Delegate: Equatable {
        case addNotification(Reminder)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.selectWeekDays, action: /Action.selectWeekDays) {
            SelectWeekDaysFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .addNotificationIfAllowed:
             
                return .run { [self, notification = Reminder(id: UUID(), days: state.selectWeekDays.selectedWeekDays, time: state.time, title: state.notificationTitle, description: state.notificationMessage)] send in
                    
                    let result = await notificationHelper.askUserToAllowNotifications()
                    
                    if !result.didAccept {
                        await send(.userNotAllowedNotifications)
                        await self.dismiss()
                    }
                    
                    await send(.delegate(.addNotification(notification)))
                    await self.dismiss()
                }
            case .binding(_):
                
                return .none
                
            case .delegate(_):
                return .none
                
            case .selectWeekDays:
                
                return .none

            case .userNotAllowedNotifications:
                 // TODO: Show error,
                
                return .none
            }
        }
    }
}
