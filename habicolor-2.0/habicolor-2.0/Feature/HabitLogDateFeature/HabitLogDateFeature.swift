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
        var date = Date()
        var emoji: Emoji?
    }
    
    enum Action: Equatable {
        case didLogForDate(Emoji)
        case setLogDate(Date)
        case saveLogAndDismiss
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .didLogForDate(let emoji):
                
                state.emoji = emoji
                
                return .none
                
            case .setLogDate(let date):
                
                state.date = date
                
                return .none
                
            case .saveLogAndDismiss:
                
                guard let emoji = state.emoji else { return .none }
                
                // TODO: delete log or this date
                if let _ = client.logHabit(state.habit.id, HabitLog(id: UUID(), score: emoji.rawValue, logDate: state.date)).data {
                    
                    
                }
                
                return .run { send in
                    
                    await dismiss()
                }
            }
        }
    }
    
}
