//
//  AddHabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct AddHabitFeature: Reducer {

    struct State: Equatable {
        
        @BindingState var habitName: String = ""
        @BindingState var habitColor: Color = .red
        @BindingState var habitMotication: String = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case saveButtonTapped
        
        enum Delegate: Equatable {
            case saveHabit(Habit)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
         
            
            switch action {
            case .saveButtonTapped:
                
                
                return .run { [habit = Habit(name: state.habitName, color: .red, weekHistory: [0, 2, 3])] send in
                    
                    await send(.delegate(.saveHabit(habit)))
                    await dismiss()
                }
            case .binding(_):
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}
