//
//  HabitDetailView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import ComposableArchitecture


struct HabitDetailFeature: Reducer {
    
    let habitLogClient: LogClient
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var habit: Habit
        var logs: [HabitLog] = []
    }
    
    enum Action: Equatable {
        case editHabitTapped(Habit)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        case loadLogs
        
        enum Delegate: Equatable {
            case habitUpdated(Habit)
        }
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .editHabitTapped:
                
                state.destination = .edit(
                    AddHabitFeature.State(
                        habitName: state.habit.name,
                        habitDescription: state.habit.description,
                        habitColor: state.habit.color,
                        weekGoal: state.habit.weekGoal,
                        habitId: state.habit.id,
                        notifications: state.habit.notifications
                    )
                )
                
                return .none
                
            case .loadLogs:
                
                if let habitRegister = habitLogClient.all(state.habit.id).data {
                    state.logs = habitRegister
                }
                
                return .none
                
            case let .destination(.presented(.edit(.delegate(.editHabit(habit))))):
                
                state.habit = habit
                
                return .none
                
            case .destination:
                
                return .none
                
            case .delegate:
                
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .onChange(of: \.habit) { oldValue, newValue in
            Reduce { state, action in
                    .send(.delegate(.habitUpdated(newValue)))
            }
        }
    }
    
    
    // modal
    struct Destination: Reducer {
        
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case edit(AddHabitFeature.State)
        }
        
        enum Action: Equatable {
            case edit(AddHabitFeature.Action)
            case alert(Alert)
            
            enum Alert {
                case cancel
                case openSettings
            }
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.edit, action: /Action.edit) {
                AddHabitFeature()
            }
        }
    }
}

//  MARK: ALERT DEFINITIONS

extension AlertState where Action == HabitDetailFeature.Destination.Action.Alert {
    
    static let pushSettingsDisabled = Self {
        TextState("Notification settings are disabled") // TODO: Translations
    } actions: {
        ButtonState(role: .cancel, action: .cancel) {
            TextState("Cancel") // TODO: Translations
        }
        
        ButtonState(action: .openSettings) {
            TextState("Open Settings") // TODO: Translations
        }
    } message: {
        TextState("Please enable your pushnotification settings to make use of the reminders functionality") // TODO: Translations
    }
    
}
