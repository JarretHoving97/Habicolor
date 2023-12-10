//
//  AddNotificationFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/10/2023.
//


import Foundation
import ComposableArchitecture

class AddNotificationFeature: Reducer {
    
    let notificationHelper = NotificationPermissions()
    
    struct State: Equatable {
        @BindingState var time = Date()
        @BindingState var notificationMessage: String = ""
        @BindingState var notificationTitle: String = ""
        var selectWeekDays = SelectWeekDaysFeature.State(selectedWeekDays: [])
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case addNotification
        case selectWeekDays(SelectWeekDaysFeature.Action)
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
            }
        }
    }
}
