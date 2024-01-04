//
//  TabbarFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 04/01/2024.
//

import Foundation
import ComposableArchitecture

struct TabbarFeature: Reducer {

    struct State: Equatable {
        var currentTab: Tab
        var habitList: HabitListFeature.State
        var settings: SettingsFeature.State
    }
    
    enum Action {
        case habitList(HabitListFeature.Action)
        case settings(SettingsFeature.Action)
        
        case didChangeTab(Tab)
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.habitList, action: /Action.habitList) {
            HabitListFeature(client: .live)
        }
        
        Scope(state: \.settings, action: /Action.settings) {
            SettingsFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .didChangeTab(let tab):
                
                state.currentTab = tab
                
                return .none
                
            case .settings:
                
                return .none
                
            case .habitList:
                
                return .none
        
            }
        }
    }
}

extension TabbarFeature {
    
    public enum Tab: Hashable {
        case habits
        case settings
        case logbook
    }
}
