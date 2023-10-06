//
//  AddHabitLogFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture

struct AddHabitLogFeature: Reducer {
    
    struct State: Equatable {
        var score: Int?
    }
    
    enum Action: Equatable {
        case addLogPressed
        case dismissPressed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            return .none
        }
    }
}
