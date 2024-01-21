//
//  TemplateSelectionFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/01/2024.
//

import Foundation
import ComposableArchitecture

struct TemplateSelectionFeature: Reducer {
    
    struct State: Equatable {
        var currentBpm = HeathBpmFeature.State()
    }
    
    enum Action: Equatable {
        case cuurentBpm(HeathBpmFeature.Action)
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didTapTemplate(HealthCase)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.currentBpm, action: /Action.cuurentBpm) {
            HeathBpmFeature(bpmReadable: CurrentBPMReader())
        }
    
        Reduce { state, action in
         
            switch action {
                
            case .cuurentBpm(.delegate(.didTapSelf)):
                
                return .run { [bpm = state.currentBpm.currentBpm?.data] send in
                    
                    guard let bpm else { return }
                    
                    HapticFeedbackManager.impact(style: .soft)
                    
                    await send(.delegate(.didTapTemplate(.vital(.bpm(bpm)))))
                    
                    await dismiss()
                }
                
            case .cuurentBpm:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
