//
//  ChooseHealthTemplateFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import Foundation
import ComposableArchitecture

enum HealthKitError: Error, Equatable {
    case noAccessError
    case unAuthorizedError
}

struct HealthTemplateButtonFeature: Reducer {

    struct State: Equatable {
        
        var template: HealthTemplate = HealthTemplate(template: .none)
        
        init(template: HealthTemplate) {
            self.template = template
        }
    }
    
    enum Action: Equatable {
        case didTapSelectTemplate
        case templateError(HealthKitError)
        case didChooseTemplate(HealthTemplate)
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            case .didChooseTemplate(let template):
                
            
                
                state.template = template
                
                return .none

                
            case .didTapSelectTemplate:
                
                return .none
                
            case .templateError:
                // TODO: show erro
                
                return .none
            }
        }
    }
}
