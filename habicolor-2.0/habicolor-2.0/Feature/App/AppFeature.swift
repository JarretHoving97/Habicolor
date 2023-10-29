//
//  AppFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture


struct AppFeature: Reducer {
    
    
    
    struct State: Equatable {

    }
    
    enum Action: Equatable {

        case addHabitLogButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        
        
        Reduce { state, action in
            
            switch action {
            case .addHabitLogButtonTapped:
                return .none
            }
        }
      
    }
}
