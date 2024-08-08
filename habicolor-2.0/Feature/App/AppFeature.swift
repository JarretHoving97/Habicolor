//
//  AppFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct AppFeature: Reducer {
    
    struct State: Equatable {
        var habitListFeature = HabitListFeature.State()
        var preferredColorScheme: ColorScheme?
        
    }
    
    enum Action  {
        case habitListFeature(HabitListFeature.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.habitListFeature, action: /AppFeature.Action.habitListFeature) {
            HabitListFeature(client: .live)
        }
        
        Reduce { state, action in

            switch action {
                
            case let .habitListFeature(.path(.element(id: _, action: .settingsList(.setColorScheme(scheme))))):
                
                if scheme == trans("settings_view_color_scheme_option_1") {
                    state.preferredColorScheme = .light
                } else if scheme == trans("settings_view_color_scheme_option_2") {
                    state.preferredColorScheme = .dark

                } else {
                    state.preferredColorScheme = nil
                }
                
                return .none
                
            case .habitListFeature:
                
                return .none
            }
        }
    }
}
