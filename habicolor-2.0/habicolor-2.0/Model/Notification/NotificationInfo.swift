//
//  NotificationInfo.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/11/2023.
//

import Foundation
import NotificationCenter


struct NotificationInfo: Hashable, Equatable {
    var identifier: String
    var category: String
    
    // add all date components
    
    init(identifier: String, category: String) {
        self.identifier = identifier
        self.category = category
    }
    
    init(request: UNNotificationRequest) {
        self.identifier = request.identifier
        self.category = request.content.userInfo[NotificationUserInfoKey.categoryIdentifierKey] as? String ?? ""
    }
}
