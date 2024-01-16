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
        var chooseTemplate = ChooseHealthTemplateFeature.State(template: .init(template: .none))
    }
    
    enum Action: Equatable {
        case choosteTemplate(ChooseHealthTemplateFeature.Action)
        
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.chooseTemplate, action: /Action.choosteTemplate) {
            ChooseHealthTemplateFeature(
                healthRequest: ReadHealthPermissionRequest(
                    options: Set(
                        [
                            HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        ]
                    )
                )
            )
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .choosteTemplate(.didTapSelectTemplate):

                // TODO: Present sheet with templates
                return .none
            case .choosteTemplate:
                return .none
            }
        }
    }
}
