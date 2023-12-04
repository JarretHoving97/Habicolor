//
//  NotificationClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import Foundation
import NotificationCenter


struct NotificationClient {
    
    var create: (_ info: NotificationInfo) -> UNNotificationRequest
    
    var all: (_ predicate: String?, _ completion: @escaping ([UNNotificationRequest]) -> Void) -> Void
}

extension NotificationClient {
    
    
    static let live = NotificationClient(
        create: { info in
           return NotificationProvider.shared.create(for: UUID().uuidString, title: info.category, message: "", dateComponents: DateComponents())
        },
        all: { category, completion in
            NotificationProvider.shared.findNotifications(category, completion: completion)
        }
    )
}
