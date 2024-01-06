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
        
        var preferredColorScheme: ColorScheme?
        
        var tabBar = TabbarFeature.State(
            currentTab: .habits,
            habitList: HabitListFeature.State(),
            settings: SettingsFeature.State())
        
        var showToolbar: Bool = true
    }
    
    enum Action  {
        case tabBar(TabbarFeature.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.tabBar, action: /Action.tabBar) {
            TabbarFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            case let .tabBar(.settings(.setColorScheme(scheme))):
                
                if scheme == trans("settings_view_color_scheme_option_1") {
                    state.preferredColorScheme = .light
                } else if scheme == trans("settings_view_color_scheme_option_2") {
                    state.preferredColorScheme = .dark
                    
                } else {
                    state.preferredColorScheme = nil
                }
                
                return .none
                
            case .tabBar:
                return .none
                
            }
        }
    }
}
