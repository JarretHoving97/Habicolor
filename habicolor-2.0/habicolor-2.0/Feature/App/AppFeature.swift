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
                
                if scheme == "Light" {
                    state.preferredColorScheme = .light
                } else if scheme == "Dark" {
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
