//
//  SelectWeekDaysFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 19/10/2023.
//

import ComposableArchitecture
import Foundation

class SelectWeekDaysFeature: Reducer {
  
    struct State: Equatable {
        var selectedWeekDays: [WeekDay]
    }
    
    enum Action: Equatable {
        case didTapWeekDay(WeekDay)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .didTapWeekDay(let weekday):
                
                if state.selectedWeekDays.contains(weekday) {
                    HapticFeedbackManager.impact(style: .rigid)
                    state.selectedWeekDays.removeAll(where: {$0 == weekday})
                } else {
                    HapticFeedbackManager.impact(style: .medium)
                    state.selectedWeekDays.append(weekday)
                }
        
                return .none
            }
        }
    }
}
