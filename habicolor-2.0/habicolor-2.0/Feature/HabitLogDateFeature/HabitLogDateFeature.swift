//
//  HabitLogDateFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import Foundation
import ComposableArchitecture

struct HabitLogDateFeature: Reducer {
    
    let client: LogClient
    
    struct State: Equatable {
        let habit: Habit
        var date = Date().adding(-1, .day)!
        var emoji: Emoji?
    }
    
    enum Action: Equatable {
        case didLogForDate(Emoji)
        case setLogDate(Date)
        case saveLogAndDismiss
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didLogToday(habit: Habit, emoji: Emoji?)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .didLogForDate(let emoji):
        
                HapticFeedbackManager.impact(style: .rigid)
                
                state.emoji = emoji
                
                return .none
                
            case .setLogDate(let date):
                
                state.date = date
                
                return .none
                
            case .saveLogAndDismiss:
                
                guard let emoji = state.emoji else { return .none }
                
                
                let logDate = state.date.adding(1, .hour)! // Adding one hour for correct day with fetching
    
                // add
                if let _ = client.logHabit(state.habit.id, HabitLog(id: UUID(), score: emoji.rawValue, logDate: logDate)).data {}
                
                return .run { [logDate = state.date, habit = state.habit, emoji = state.emoji] send in
                    
                    if logDate.isInToday {
                        
                        await send(.delegate(.didLogToday(habit: habit, emoji: emoji)))
                    }
                    
                    await dismiss()
                }
            case .delegate:
                return .none
            }
        }
    }
    
}
