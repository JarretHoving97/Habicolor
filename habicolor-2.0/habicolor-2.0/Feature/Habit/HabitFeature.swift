//
//  HabitFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import Foundation
import ComposableArchitecture

struct HabitFeature: Reducer {
    
    let client: LogClient
    
    struct State: Equatable, Identifiable {
        let id = UUID()
        var habit: Habit
        var collapsed: Bool = true
        var selectedEmoji: Emoji?
        var showAsCompleted: Bool = false
    }
    
    enum Action {
        case showDetail
        case showEmojiesTapped
        case didSelectEmoji(Emoji)
        case selectEmojiDebounced
        case delegate(Delegate)
        
        enum Delegate {
            case didLogForHabit(habit: Habit, emoji: Emoji?)
            case didTapSelf(Habit)
        }
    }
    
    private enum CancelID { case emojiAction }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .delegate:
                return .none
                
            case .showDetail:
                
                return .none
                
            case .didSelectEmoji(let emoji):
                
                if state.selectedEmoji == emoji {
                    HapticFeedbackManager.impact(style: .soft)
                    state.selectedEmoji = nil
                } else {
                    HapticFeedbackManager.impact(style: .rigid)
                    state.selectedEmoji = emoji
                }
            
                return .none
                
                
            case .showEmojiesTapped:
                
                HapticFeedbackManager.impact(style: .light)
                
                state.collapsed.toggle()
            
                return .none
                
            case .selectEmojiDebounced:
                
                guard let emoji = state.selectedEmoji else {
                    // TODO: Delete habit log
                    
                    return  .none
                }
                
                if !state.collapsed {
                    
                    state.collapsed = true
                }
                
                return .run(operation: { [habit = state.habit, emoji] send in
        
                    if let _ = client.logHabit(habit.id, HabitLog(id: UUID(), score: emoji.rawValue, logDate: .startOfDay(Date()))).data {
                       /// data saved, so send did log
                       await send(.delegate(.didLogForHabit(habit: habit, emoji: emoji)), animation: .easeOut)
                   }
                })
                .cancellable(id: CancelID.emojiAction)// TODO: Save Log call debounce
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
