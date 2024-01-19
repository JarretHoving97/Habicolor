//
//  HeathBpmFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/01/2024.
//

import Foundation
import ComposableArchitecture

struct HeathBpmFeature: Reducer {
    
    var bpmReadable: CurrentHearthBPMReadable
    
    struct State: Equatable {
        var isLoading: Bool = false
        var currentBpm: String = ""
    }
    
    enum Action {
        case startLoadingBpm
        case didLoadBpm(String)
    }
    
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            case .startLoadingBpm:
                state.isLoading = true
                
    
                return .run { send in
                    
                    do {
                        let result = try await bpmReadable.read()
                        
                        await send(.didLoadBpm(result))
                        
                    } catch {
                        
                        Log.debug(String(describing: error))
                    }
                }
            case .didLoadBpm(let result):

                state.isLoading = false
                state.currentBpm = result
                
                return .none
            }
            
        }
    }
}
