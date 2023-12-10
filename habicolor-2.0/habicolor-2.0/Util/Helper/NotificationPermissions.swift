//
//  NotificationPermissions.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import SwiftUI

typealias NotificationPermissionCallBack = (didAccept: Bool, error: Error?)

class NotificationPermissions {
    @AppStorage("habicolor.did.ask.notification.permission") var didAskForNotificationPermissions: Bool = false
}

extension NotificationPermissions {
    
    func askUserToAllowNotifications() async -> NotificationPermissionCallBack {
        
        do {
            let didAccept =  try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            
            return (didAccept, nil)
        }
        catch {
            Log.error(String(describing: error))
            
            return (false, error)
        }
    }
}
