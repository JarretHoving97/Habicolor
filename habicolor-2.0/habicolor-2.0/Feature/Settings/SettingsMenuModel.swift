//
//  SettingsMenuData.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import Foundation

class SettingsMenuModel {
    
    /// menu items to show in SettingsListView
    static var menu: [String: [SettingsItem]] {
        
        return [
        "extra": [
            SettingsItem(title: "Premium", type: .normal("star.fill")),
            SettingsItem(title: "Release notes", type: .normal("book.pages")),
            SettingsItem(title: "Review", type: .normal("heart.fill"))
        ],
        
        "settings": [
            SettingsItem(title: "Haptic feedback", type: .toggle)
        ],
        
        "contact": [
            SettingsItem(title: "Mail", type: .normal("envelope.fill")),
            SettingsItem(title: "Social", type: .normal("person.2")),
        ]
        ]
    }
}
