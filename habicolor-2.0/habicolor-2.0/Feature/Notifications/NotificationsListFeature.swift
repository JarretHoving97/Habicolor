//
//  NotificationsListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import Foundation
import ComposableArchitecture


struct NotificationsListFeature: Reducer {
    
    let localNotificationClient: NotificationClient
    let notificationStorageSerice: ReminderClient

    
    struct State: Equatable {
        var habits: [Habit]
        var reminders: [Habit: [Reminder]] = [:]
        var predicate: String?
    }
    
    enum Action: Equatable {
        case fetchLocalNotifications
        case didFetchNotificatios([Habit: [Reminder]])
        case deleteNotification(habit: Habit, reminder: Reminder)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .fetchLocalNotifications:
        
    
                return .run { send in
                    
                    if let result = await localNotificationClient.all(nil) {
                
                        await send(.didFetchNotificatios([.example: ReminderMapper.reduce(result)]))
                    }
                }
                

            
            case .deleteNotification(habit: let habit, reminder: let reminder):
                
                HapticFeedbackManager.impact(style: .soft)
                 
//                notificationStorageSerice.deleteNotification(reminder.id)
                
                state.reminders[habit]?.removeAll(where: {$0.id == reminder.id})
                
                if state.reminders[habit]?.count == 0 {
                    state.reminders.removeValue(forKey: habit)
                }
        
                return .run { [reminder = reminder.id.uuidString] send in
                    await localNotificationClient.deleteForId(reminder)
                }
            case let .didFetchNotificatios(notificaitons):
                
                state.reminders = notificaitons
                
                return .none
            }
        }
    }
}
