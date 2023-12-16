//
//  SettingsFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsFeature: Reducer {
    @AppStorage("nl.habicolor.colorscheme") var prefferedColorScheme: String?
    
    struct State: Equatable {
        var prefferedColorScheme: String = "Automatic"
    }
    
    enum Action: Equatable {
        case didToggleItem(SettingsItem)
        case setColorScheme(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .setColorScheme(let scheme):
                
                prefferedColorScheme = scheme
                
                state.prefferedColorScheme = scheme
                
                return .none
            case .didToggleItem(let item):
                
                return .none
            }
           
            return .none
        }
    }
}
