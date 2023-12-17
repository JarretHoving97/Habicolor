//
//  SettingsFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsFeature: Reducer {

    
    struct State: Equatable {
        var prefferedColorScheme: String = "System"
        var hapticFeebackEnabled: Bool
        
        init() {
            self.prefferedColorScheme = AppSettingsProvider.shared.userPrefferedColorScheme
            self.hapticFeebackEnabled = AppSettingsProvider.shared.hapticFeedbackEnabled
        }
    }
    
    enum Action: Equatable {
        case didToggleHapticFeedback(Bool)
        case setColorScheme(String)
        case configureSettingsInfo
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .configureSettingsInfo:
                
                state.prefferedColorScheme = AppSettingsProvider.shared.userPrefferedColorScheme
                state.hapticFeebackEnabled = AppSettingsProvider.shared.hapticFeedbackEnabled
                
                return .none
            
                
            case .setColorScheme(let scheme):
                
                AppSettingsProvider.shared.userPrefferedColorScheme = scheme
                
                state.prefferedColorScheme = scheme
                
                HapticFeedbackManager.impact(style: .rigid)
                
                return .none
                
            case .didToggleHapticFeedback(let bool):
                
                state.hapticFeebackEnabled = bool
                AppSettingsProvider.shared.hapticFeedbackEnabled = bool
                
                return .none
            }

        }
    }
}
