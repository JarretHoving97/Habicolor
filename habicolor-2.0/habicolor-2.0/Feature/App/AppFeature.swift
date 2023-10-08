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

        var habitList = HabitListFeature.State()
    }
    
    enum Action: Equatable {
        case addHabitLogButtonTapped
        case habitList(HabitListFeature.Action)

    }
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.habitList, action: /Action.habitList) {
            HabitListFeature()
        }
        
        Reduce { state, action in
            
            switch action {
            case .addHabitLogButtonTapped:
     
                
                return .none
                
            case .habitList:
                
                return .none
            
            }
        }
    }
}
