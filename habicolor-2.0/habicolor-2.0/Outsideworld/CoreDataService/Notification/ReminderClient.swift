//
//  NotificationClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/10/2023.
//

import Foundation

struct ReminderClient {
    
    var all: (_ habitId: UUID) -> PersistenceListResult<Reminder>
    
    var add: (_ habitId: UUID, _ notification: Reminder) -> PersistenceResult<Reminder>
    
    var delete: (_ id: UUID ) -> Void
    
    var deleteNotification: (_ notification: UUID) -> Void
}

extension ReminderClient {
    
    static let live = ReminderClient(
        all: { habitId in
            
            ReminderProvider.current.all(habitId)
        },
        
        add: { habitId, notification in
            
            ReminderProvider.current.add(habitId, notification: notification)
        },
        
        delete: { habit in
            ReminderProvider.current.deleteAll(for: habit)
        }, 
        
        deleteNotification: { notication in
            
            ReminderProvider.current.delete(notication)
        }
    )
}
