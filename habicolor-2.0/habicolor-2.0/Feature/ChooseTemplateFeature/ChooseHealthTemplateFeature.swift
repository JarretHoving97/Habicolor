//
//  ChooseHealthTemplateFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import Foundation
import ComposableArchitecture


struct ChooseHealthTemplateFeature: Reducer {
    
    struct State: Equatable {
        var template: HealthTemplate = HealthTemplate(template: .none)
        
        init(template: HealthTemplate) {
            self.template = template
        }
    }
    
    enum Action: Equatable {
        case didTapSelectTemplate
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
            }
        }
    }
}
