//
//  NotebookFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 22/01/2024.
//

import SwiftUI
import ComposableArchitecture

// Holds state to notebook list feature
// Captures interactions like add, edit and delete nodes so it can inject new states
// To the notebook list

class NotebookFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        @PresentationState var destination: Destination.State?
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case addNewNotePressed
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .addNewNotePressed:
                
                HapticFeedbackManager.impact(style: .light)
                
                state.destination = .addNoteFeature(
                    AddNoteFeature.State(
                        currentTemplateState: .init(
                            template: .init(
                                template: .none
                            )
                        )
                    )
                )
            
                return .none
                
            case .path:
                return .none
                
            case .destination:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

extension NotebookFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case addNoteFeature(AddNoteFeature.State)
        }
        
        enum Action: Equatable {
            case addNoteFeature(AddNoteFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.addNoteFeature, action: /Action.addNoteFeature) {
                AddNoteFeature()
            }
        }
    }
}

extension NotebookFeature {
    
    struct Path: Reducer {
    
        enum State: Equatable {
            case addNoteFeature(AddNoteFeature.State)
        }
        
        enum Action: Equatable {
            case addNoteFeature(AddNoteFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.addNoteFeature, action: /Action.addNoteFeature) {
                AddNoteFeature()
            }
        }
    }
}
