//
//  HabitTemplateFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import Foundation
import ComposableArchitecture

struct HabitTemplateFeature: Reducer {
    
    struct State: Equatable {
        
        let templates: [TemplateModel]
        var selectedTemplate: TemplateModel?
    }
    
    enum Action: Equatable {
        case didSelectTamplate(TemplateModel)
        case didSelectTemplate
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didSelectTemplate(TemplateModel?)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .didSelectTamplate(let template):
                HapticFeedbackManager.selection()
                // remove if identical
                if template == state.selectedTemplate {
                    return .run { send in
                        await send(.didSelectTemplate, animation: .easeOut)
                    }
                }
                
                // run
                state.selectedTemplate = template
                
                return .run { [template] send in
                    await send(.delegate(.didSelectTemplate(template)))
                }
                
            case .didSelectTemplate:
                
                state.selectedTemplate = .none
                
                return .run { send in
                    
                    await send(.delegate(.didSelectTemplate(nil)))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
