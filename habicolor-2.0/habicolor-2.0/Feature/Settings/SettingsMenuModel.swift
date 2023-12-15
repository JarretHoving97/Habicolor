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
                SettingsItem(title: "Upgrade to Plus", type: .normal("plus.app")),
                SettingsItem(title: "Release notes", type: .normal("book.pages")),
                SettingsItem(title: "Review", type: .normal("heart.fill"))
            ],
            
            "App": [
                SettingsItem(title: "Haptic feedback", type: .toggle("water.waves")),
                SettingsItem(title: "Color Scheme", type: .picker("moon.fill"))
            ],
            
            "About": [
                SettingsItem(title: "Mail", type: .normal("envelope.fill")),
                SettingsItem(title: "Socials", type: .normal("person.2")),
                SettingsItem(title: "Terms of Use", type: .normal("doc.text")),
                SettingsItem(title: "Privacy Policy", type: .normal("hand.raised.square")),
            ]
        ]
    }
}
