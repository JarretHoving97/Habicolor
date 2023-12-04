//
//  NotificationPermissions.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import SwiftUI

typealias NotificationPermissionCallBack = (_ didAccept: Bool, _ error: Error?) -> Void

class NotificationPermissions {
    @AppStorage("habicolor.did.ask.notification.permission") var didAskForNotificationPermissions: Bool = false
}

extension NotificationPermissions {
    
    func askUserToAllowNotifications(callback: @escaping NotificationPermissionCallBack) {
        guard !didAskForNotificationPermissions else { return }
        didAskForNotificationPermissions = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: callback)
    }
}
