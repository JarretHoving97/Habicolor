//
//  NSNotification.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/10/2023.
//

import Foundation
import CoreData

extension NSReminder {
    
    /// create a new instance of nsNotifications
    static func newInstance(of notification: Reminder, context: NSManagedObjectContext) -> NSReminder {
    
        let nsNotification = NSReminder(context: context)
        
        nsNotification.id = notification.id
//        nsNotification.days = NSSet(array: notification.days)
        nsNotification.time = notification.time
        nsNotification.title = notification.title
        nsNotification.message = notification.description
        
        return nsNotification
    }
    
}
