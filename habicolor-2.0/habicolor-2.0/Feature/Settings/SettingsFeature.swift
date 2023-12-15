//
//  SettingsFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import Foundation
import ComposableArchitecture

struct SettingsFeature: Reducer {
    
    struct State: Equatable {
        var menuItems: [String: [SettingsItem]]
    }
    
    enum Action: Equatable {
        case didToggleItem(SettingsItem)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didToggleItem(let item):
                
                return .none
            }
           
            return .none
        }
    }
}
