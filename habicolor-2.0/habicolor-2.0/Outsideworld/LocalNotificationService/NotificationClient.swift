//
//  NotificationClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import Foundation
import NotificationCenter


struct NotificationClient {
    
    var create: (_ info: NotificationInfo) async -> UNNotificationRequest
    
    var all: (_ predicate: String?) async -> [NotificationInfo]?
}

extension NotificationClient {
    
    static let live = NotificationClient(
        create: { info in
            return await NotificationProvider.shared.create(
                for: info.identifier,
                title: info.category,
                message: info.body,
                dateComponents: info.dateComponents
            )
        },
        
        all: { predicate in
            guard let results = await NotificationProvider.shared.findNotifications(predicate) else { return nil}
            return results.map({NotificationInfo(request: $0)})
        }
    )
}
