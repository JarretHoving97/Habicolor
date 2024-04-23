//
//  NotificationClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 03/12/2023.
//

import Foundation
import NotificationCenter


struct NotificationClient {
    
    var create: ((NotificationInfo) async -> Void)
    
    var deleteForCategory: (_ category: String) async -> Void
    
    var deleteForId: (_ reminderId: String) async -> Void
    
    var all: (_ predicate: String?) async -> [LocalNotification]?
}

extension NotificationClient {
    
//    static let live = NotificationClient(
//        create: { info in
//            
//            // delete existing ones first to prevent unexpected multiple triggers
//            let existing = await NotificationProvider.shared.findNotifications(info.category)
//            NotificationProvider.shared.removeLocalNotifications(for: existing.map({$0.identifier}))
//            
//            // create them again
//            await NotificationProvider.shared.create(
//                for: info.identifier,
//                title: info.title,
//                message: info.body,
//                dateComponents: info.dateComponents,
//                info: [NotificationUserInfoKey.categoryIdentifierKey: info.category])
//            
//        },
//        
//        deleteForCategory: { category in
//            let existing = await NotificationProvider.shared.findNotifications(category)
//            NotificationProvider.shared.removeLocalNotifications(for: existing.map({$0.identifier}))
//        },
//        
//        deleteForId: { id in
//            NotificationProvider.shared.removeLocalNotifications(for: [id])
//        },
//        
//        all: { predicate in
//            return await NotificationProvider.shared.findNotifications(predicate)
//        }
//    )
    
    static var localCenter: NotificationClient = {
        var manager = AppLocalNotificationManager()
        
        return NotificationClient(
            
            create: { info in
                
                
                try? await manager.addNotification(
                    LocalNotification(
                        id: info.identifier,
                        title: info.title,
                        subtitle: info.body,
                        sound: .default,
                        userInfo: ["category": info.category],
                        dateComponents: info.dateComponents,
                        repeats: true
                    )
                )
            },
            deleteForCategory: {category in
            },
            deleteForId: {id in
                
            },
            all: { category in
                            
                return await manager.getPendingRequests()
            }
        )
    }()
}


