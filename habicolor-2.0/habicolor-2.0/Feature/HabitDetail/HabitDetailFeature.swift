//
//  HabitDetailView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import ComposableArchitecture
import Foundation

struct HabitDetailFeature: Reducer {
    
    let habitLogClient: LogClient
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        
        var habitsStatsFeature: HabitStatsFeature.State
        var contributionFeature: ContributionFeature.State
        
        var habit: Habit
        var logs: [HabitLog] = []
        
        init(habit: Habit, contributionFeature: ContributionFeature.State, habitStatsFeature: HabitStatsFeature.State) {
            self.habit = habit
            self.habitsStatsFeature = habitStatsFeature
            self.contributionFeature = contributionFeature
        }
        
        init(habit: Habit) {
            self.habit = habit
            self.habitsStatsFeature = HabitStatsFeature.State(habit: habit)
            self.contributionFeature = ContributionFeature.State(habit: habit.id)
        }
    }
    
    enum Action: Equatable {
        case editHabitTapped(Habit)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        case didUpdateHabit(Habit)
        case habitsStatsFeature(HabitStatsFeature.Action)
        case contributionFeature(ContributionFeature.Action)
        case showDeleteAlert
        case loadLogs
        
        enum Delegate: Equatable {
            case confirmDeletion(Habit)
            case habitUpdated(Habit)
            case didTapNotficaitions(Habit)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.habitsStatsFeature, action: /Action.habitsStatsFeature) {
            HabitStatsFeature(client: .live)
        }
        
        Scope(state: \.contributionFeature, action: /Action.contributionFeature) {
            ContributionFeature(client: .live)
        }
        
        Reduce { state, action in
            
            switch action {
                
            case .didUpdateHabit(let updatedHabit):
                
                state.habit = updatedHabit
                state.habitsStatsFeature = HabitStatsFeature.State(habit: updatedHabit)
                
                return .run { [updatedHabit] send in

                    await send(.habitsStatsFeature(.loadWeeksCompletionRate))
                    await send(.habitsStatsFeature(.loadWeeksAverageScore))
                    await send(.delegate(.habitUpdated(updatedHabit)))
                }
                
            case .editHabitTapped:
                
                state.destination = .edit(
                    AddHabitFeature.State(
                        habitName: state.habit.name,
                        habitDescription: state.habit.description,
                        habitColor: state.habit.color,
                        weekGoal: state.habit.weekGoal,
                        habitId: state.habit.id,
                        notifications: []
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
                
                
            case .destination(.presented(.alert(.acceptDeleteHabit))):
                
                
                return .run { [habit = state.habit] send in
                    await send(.delegate(.confirmDeletion(habit)))
                    await dismiss()
                }
                
            case .showDeleteAlert:
                
                HapticFeedbackManager.notification(type: .error)
                state.destination = .alert(.deleteHabitAlert)
                
                return .none
                
            case .destination:
                return .none
                
            case .delegate:
                return .none
                
            case .habitsStatsFeature:
                return .none
                
            case .contributionFeature:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .onChange(of: \.habit) { oldValue, newValue in
            Reduce { state, action in
                
                return .run { send in
                    await send(.didUpdateHabit(newValue))
                }
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
                case acceptDeleteHabit
                case cancel
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
    
    static let deleteHabitAlert = Self {
        TextState("Are you sure?") // TODO: Translations
    } actions: {
        ButtonState(role: .destructive, action: .acceptDeleteHabit) {
            TextState("Yes") // TODO: Translations
        }
        ButtonState(role: .cancel, action: .cancel) {
            TextState("Cancel") // TODO: Translations
        }
    } message: {
        TextState("You want to delete this habit? All data will be lost.") // TODO: Translations
    }
}
