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
        
        @PresentationState var destination: Destination.State?
        
        let id = UUID()
        var habit: Habit
        var collapsed: Bool = true
        var selectedEmoji: Emoji?
        var showAsCompleted: Bool = false
        var date = Date()
    }
    
    enum Action {
        case showDetail
        case showEmojiesTapped
        case didSelectEmoji(Emoji)
        case selectEmojiDebounced
        case delegate(Delegate)
        case showDidLogToday
        case setDate(Date)
        case didTapLogForDate
        case destination(PresentationAction<Destination.Action>)
        
        enum Delegate {
            case didLogForHabit(habit: Habit, emoji: Emoji?)
            case didUndoHabit(Habit)
            case didTapSelf(Habit)
        }
    }
    
    private enum CancelID { case emojiAction }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
      
                
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
                
                // if already selected, delete log
                guard let emoji = state.selectedEmoji else {
                    // TODO: Delete habit log
                    if let todaysLog = client.find(state.habit.id, Date().startOfDay).data {
                        
                       if let result = client.undoLog(todaysLog.id).data {
                           Log.debug(result)
                           state.selectedEmoji = nil
                           state.showAsCompleted = false
                           
                           state.collapsed = true
                        }
                    }
                    
                    return  .run { [habit = state.habit] send in
                        await send(.delegate(.didUndoHabit(habit)), animation: .easeIn)
                    }
                }
                
                
                // else create log
                if !state.collapsed {
                    state.collapsed = true
                }
                
                return .run(operation: { [habit = state.habit, emoji] send in
        
                    if let _ = client.logHabit(habit.id, HabitLog(id: UUID(), score: emoji.rawValue, logDate: Date().startOfDay)).data {
                       /// data saved, so send did log
                       await send(.delegate(.didLogForHabit(habit: habit, emoji: emoji)), animation: .easeOut)
                   }
                })
                .cancellable(id: CancelID.emojiAction)// TODO: Save Log call debounce
                
            case .showDidLogToday:
                
                if let result = client.find(state.habit.id, Date().startOfDay).data {
                    state.selectedEmoji = result.emoji
                    state.showAsCompleted = true
                }
                
                return .none
                
            case let .destination(.presented(.habitLogdateFeature(.delegate(.didLogToday(habit, emoji))))):
                
                return .run { send in
    
                    try? await Task.sleep(seconds: 0.4) // modal presentation closure time.
                    
                    await send(.showDidLogToday, animation: .easeOut)
                    await send(.delegate(.didLogForHabit(habit: habit, emoji: emoji)), animation: .easeOut)
                }
                
            case .setDate(let date):
                state.date = date

                return .none
                
            case .didTapLogForDate:
                
                state.destination = .habitLogdateFeature(.init(habit: state.habit))
                
                return .none
                
            case .destination:
                return .none
                
            case .delegate:
                return .none
                
            case .showDetail:
                
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
    }
}

extension HabitFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case habitLogdateFeature(HabitLogDateFeature.State)
        }
        
        enum Action: Equatable {
            case habitLogdateFeature(HabitLogDateFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.habitLogdateFeature, action: /Action.habitLogdateFeature) {
                HabitLogDateFeature(client: .live)
            }
        }
    }
}

