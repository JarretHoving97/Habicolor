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

struct ChooseHealthTemplateFeature: Reducer {
    
    let healthRequest: HealthKitRequest
    
    struct State: Equatable {
        var template: HealthTemplate = HealthTemplate(template: .none)
        
        init(template: HealthTemplate) {
            self.template = template
        }
    }
    
    enum Action: Equatable {
        case healthRequestError(HealthKitError)
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
                
                return .run { send in
                    // TODO: Show alert with template explanation
                    do {
                        try await healthRequest.request()
                    } catch {
                        await send(.healthRequestError(HealthKitError.noAccessError))
                    }
                 
                }
            case .healthRequestError:
                Log.debug("TODO: Show dialog")
                return .none
            }
        }
    }
}
