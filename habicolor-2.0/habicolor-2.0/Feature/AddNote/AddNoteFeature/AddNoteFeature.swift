//
//  AddNoteFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 14/01/2024.
//

import Foundation
import ComposableArchitecture
import HealthKit

struct AddNoteFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var currentTemplateState: HealthTemplateButtonFeature.State
    }
    
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case askForHealthpermissions
        case currentTemplateState(HealthTemplateButtonFeature.Action)
        case presentTemplateSelection
    }
    
    var body: some ReducerOf<Self> {

        Scope(state: \.currentTemplateState, action: /Action.currentTemplateState) {
            HealthTemplateButtonFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
     
            case .currentTemplateState(.didTapSelectTemplate):
                                
                HapticFeedbackManager.impact(style: .rigid)

                return .run { send in
                   
                    await send(.askForHealthpermissions)
                    await send(.presentTemplateSelection)
      
                }
                
            case .askForHealthpermissions:
            
                return .run { _ in
               
                    do {
                        let healthPermissions = ReadHealthPermissionRequest()
                        let _ = try await healthPermissions.request()
                        
                    } catch {
                        Log.debug(error.localizedDescription)
                    }
                }
            
            case .presentTemplateSelection:
                
                state.destination = .chooseTemplateFeatue(TemplateSelectionFeature.State())
                
                return .none
                
            case .destination(.presented(.chooseTemplateFeatue(.delegate(.didTapTemplate(let template))))):
   
                state.currentTemplateState = HealthTemplateButtonFeature.State(template: HealthTemplate(template: template))
                
                return .none
                
            case .destination:
                return .none
                
                
            case .currentTemplateState:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}


extension AddNoteFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case chooseTemplateFeatue(TemplateSelectionFeature.State)
            
        }
        
        enum Action: Equatable {
            case chooseTemplateFeatue(TemplateSelectionFeature.Action)
            
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.chooseTemplateFeatue, action: /Action.chooseTemplateFeatue) {
                TemplateSelectionFeature()
            }
        }
    }
}
