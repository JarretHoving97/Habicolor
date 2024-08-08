//
//  SettingsItem.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import Foundation


struct SettingsItem: Hashable, Equatable {
    
    let id: UUID = UUID()
    let title: String
    let type: SettingType
    
    enum SettingType: Equatable, Hashable {
        case normal(String)
        case toggle(String)
        case picker(String)
    }
}


