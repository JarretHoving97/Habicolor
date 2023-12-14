//
//  HabitListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitListFeature: Reducer {
    
    @AppStorage("nl.habicolor.notification.alert.disabled") var disableNotificationAlert: Bool = false
    
    let notificationHelper = NotificationPermissions()
    let localNotificationsClient: NotificationClient = .live
    
    var client: HabitClient
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var path = StackState<Path.State>()
        var habits: IdentifiedArrayOf<HabitFeature.State> = []
    }
    
    @Dependency(\.dismiss) var dismiss
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case setDone(index: Int)
        case setUndone(index: Int)
        case addHabitTapped
        case showNotificationsTapped
        case habit(id: UUID, action: HabitFeature.Action)
        case showDetail(Habit)
        case fetchHabits
        case showNotificationsSettingsAreOff
        case synchronizeNotifications(Habit)
    }
    
    var body: some ReducerOf<Self>  {
        Reduce { state, action in
            
            switch action {
                
            case .synchronizeNotifications(let habit):
                
                let notifications = NotificationInfoConverter.convert(category: habit.id, notifications: habit.notifications)
                
                return .run { [notifications] send in
                    
                   await LocalNotificationConfigurator.addNotificationsLocalNotifications(notifications)
                    
                    Log.debug("Did it work?")
                }
                
            case .fetchHabits:
                
                if let habits = client.all().data {
                    let habitsSorted = habits.sorted(by: {$0.getLastLogTimeToday() ?? Date() > $1.getLastLogTimeToday() ?? Date() })
                    state.habits = IdentifiedArray(uniqueElements: habitsSorted.map({HabitFeature.State(habit: $0)}))
                }
                
                return .none
                
            case .addHabitTapped:
                
                
                state.destination = .addHabitForm(AddHabitFeature.State(habitId: nil))
                
                return .none
                
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.habitUpdated(habit))))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none }
                
                let id = state.habits[index].habit.id
                
                if let updatedHabit = client.updateHabit(habit, id).data {
                    
                    state.habits[index].habit = updatedHabit
                }
                
                return .none
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.confirmDeletion(habit))))):
                
                
                if client.delete(habit).data == "SUCCESS" {
                    
                    guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none }
                    
                    state.habits.remove(at: index)
                }
                
                
                return .none
                
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                if let habit = client.add(habit).data {
                    
                    state.habits.insert(HabitFeature.State.init(habit: habit), at: 0)
                    
                    return .run { [self, habit] send in
                        
                        let notifcationSettings = await notificationHelper.askUserToAllowNotifications()
                        
                        if !notifcationSettings.didAccept && !habit.notifications.isEmpty && !self.disableNotificationAlert {
                            await send(.showNotificationsSettingsAreOff)
                        }
                        
                        if !habit.notifications.isEmpty  {
                            await send(.synchronizeNotifications(habit))
                        }
                        
                    }
                }
                
                return .none
                
            case .destination(.presented(.alert(.dontShowAgain))):
                
                disableNotificationAlert = true
                
                return .none
                
            case .destination(.presented(.alert(.openSettings))):
                
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return .none}
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                
                return .none
                
            case let .habit(id: _, action: .delegate(.didUndoHabit(habit))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none}
                
                if index > 0 {
                    var habitToReplace = state.habits[index]
                    habitToReplace.habit = habit
                    state.habits.remove(at: index)
                    state.habits.insert(habitToReplace, at: 0)
                }
                
                
                return .none
                
            case let .habit(id: _, action: .delegate(.didLogForHabit(habit: habit, emoji: _))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none}
                
                if index < state.habits.count {
                    var habitToReplace = state.habits[index]
                    habitToReplace.habit = habit
                    state.habits.remove(at: index)
                    state.habits.append(habitToReplace)
                }
                
                
                return .run { [index] send in
                    await send(.setDone(index: index), animation: .easeIn)
                }
                
                
            case .setDone:
                
                state.habits[state.habits.count - 1].showAsCompleted = true
                
                return .none
                
            case .setUndone(let index):
                
                state.habits[index].showAsCompleted = false
                
                return .none
                
                
            case let .habit(id: _, action: .delegate(.didTapSelf(habit))):
                
                
                return .run { [habit] send in
                    
                    await send(.showDetail(habit))
                }
                
                
            case .showDetail(let habit):
                
                state.path.append(HabitListFeature.Path.State.habitDetail(HabitDetailFeature.State(habit: habit)))
                
                return .none
                
                
            case .showNotificationsTapped:
                
                let habits = state.habits.map {$0.habit}
                
                
                state.path.append(HabitListFeature.Path.State.notificationsList(NotificationsListFeature.State(habits: habits, predicate: nil)))
                
                return .none
                
                
            case .showNotificationsSettingsAreOff:
                
                state.destination = .alert(.pushSettingsDisabled)
                
                return .none
                
            case .habit:
                
                return .none
                
            case .destination:
                return .none
                
            case .path:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        
        .forEach(\.habits, action: /HabitListFeature.Action.habit(id:action:)) {
            HabitFeature(client: .live)
        }
    }
}

// MARK: Destination
extension HabitListFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case addHabitForm(AddHabitFeature.State)
        }
        
        enum Action: Equatable {
            case addHabitForm(AddHabitFeature.Action)
            case alert(Alert)
            
            enum Alert {
                case cancel
                case openSettings
                case dontShowAgain
            }
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addHabitForm, action: /Action.addHabitForm) {
                AddHabitFeature()
            }
        }
    }
    
    
    // navigation stack
    struct Path: Reducer {
        
        enum State: Equatable {
            case habitDetail(HabitDetailFeature.State)
            case notificationsList(NotificationsListFeature.State)
        }
        
        enum Action: Equatable {
            case habitDetail(HabitDetailFeature.Action)
            case notificationsList(NotificationsListFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.habitDetail, action: /Action.habitDetail) {
                HabitDetailFeature(habitLogClient: .live)
            }
            
            Scope(state: /State.notificationsList, action: /Action.notificationsList) {
                NotificationsListFeature(notifcationSerice: .live, notificationStorageSerice: .live)
            }
        }
    }
}

//  MARK: ALERT DEFINITIONS
extension AlertState where Action == HabitListFeature.Destination.Action.Alert {
    
    static let pushSettingsDisabled = Self {
        TextState("Notification settings are disabled") // TODO: Translations
    } actions: {
        
        ButtonState(action: .openSettings) {
            TextState("Open Settings") // TODO: Translations
        }
        
        ButtonState(role: .cancel, action: .cancel) {
            TextState("Ignore") // TODO: Translations
        }
        
        ButtonState(role: .destructive, action: .dontShowAgain) {
            TextState("Don't show again") // TODO: Translations
        }
        
    } message: {
        TextState("To make use of your reminders, you should enable push notifications settings.") // TODO: Translations
    }
}
