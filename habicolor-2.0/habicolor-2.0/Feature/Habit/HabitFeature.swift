//
//  HabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture

struct HabitFeature: Reducer {
    
    struct State: Equatable {
        var habit: Habit
        var collapsed: Bool = true
        var emojiSelection: [String] = []
    }
    
    enum Action {
        case showDetail
        case logForHabit
        case showEmojiesTapped
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
            case .logForHabit:
                
                return .none
                
            case .showDetail:
                
                return .none
                
            case .showEmojiesTapped:
                
                HapticFeedbackManager.impact(style: .light)
                
                state.emojiSelection = ["😓", "🙁", "😐", "😄", "🤩"]
                
                state.collapsed.toggle()
            
                return .none
            }
        }
    }

}


extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
