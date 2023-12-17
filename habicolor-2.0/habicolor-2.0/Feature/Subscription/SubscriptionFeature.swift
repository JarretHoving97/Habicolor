//
//  SubscriptionFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 17/12/2023.
//

import Foundation
import ComposableArchitecture

class SubscriptionFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case dismissTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .dismissTapped:
                
                HapticFeedbackManager.impact(style: .soft)
                
                return .run { _ in
                    
                    await self.dismiss()
                }
            }
        }
    }
}
