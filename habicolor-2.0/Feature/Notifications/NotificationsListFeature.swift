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
        case deleteNotification(habit: Habit, reminder: Reminder)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .fetchLocalNotifications:
                
                state.habits.forEach { habit in
                    
                    let result = notificationStorageSerice.all(habit.id)
                    
                    if let data = result.data, !data.isEmpty {
                        
                        state.reminders[habit] = data
                    }
                    
                    if let error = result.error {
                        Log.error(String(describing: error))
                    }
                    
                }
                
                return .none
                
            case .deleteNotification(habit: let habit, reminder: let reminder):
                
                HapticFeedbackManager.impact(style: .soft)
                 
                notificationStorageSerice.deleteNotification(reminder.id)
                
                state.reminders[habit]?.removeAll(where: {$0.id == reminder.id})
                
                if state.reminders[habit]?.count == 0 {
                    state.reminders.removeValue(forKey: habit)
                }
        
                return .run { [reminder = reminder.id.uuidString] send in
                    await localNotificationClient.deleteForId(reminder)
                }
            }
        }
    }
}
