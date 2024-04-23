//
//  NotificationsConfigurator.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 14/12/2023.
//

import Foundation

class LocalNotificationConfigurator {
        
    static func addNotificationsLocalNotifications(_ notifications: [NotificationInfo]) async {
        
        let client: NotificationClient = .localCenter
        
        await withTaskGroup(of: Void.self) { group in
        
            for notification in notifications {
            
                group.addTask {
                    let _ = await client.create(notification)
                }
            }
            
            // Wait for all tasks to complete
            await group.waitForAll()
        }
    }
}



