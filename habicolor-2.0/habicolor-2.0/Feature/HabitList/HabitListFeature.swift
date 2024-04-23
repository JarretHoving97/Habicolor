//
//  HabitListFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Billboard

struct HabitListFeature: Reducer {
    
    @AppStorage("nl.habicolor.notification.alert.disabled") var disableNotificationAlert: Bool = false
    
    let notificationHelper = NotificationPermissions()
    let localNotificationsClient: NotificationClient = .localCenter
    
    var client: HabitClient
    var appStoreClient = StoreKitClient()
    var billBoardClient = BillboardViewModel()
    
    struct State: Equatable {
        
        @PresentationState var destination: Destination.State?
        var path = StackState<Path.State>()
        
        var settingsView = SettingsFeature.State()
        var habits: IdentifiedArrayOf<HabitFeature.State> = []
        var isSubscribed: Bool = true
        var showEmptyViewState: Bool = false
        
        var ad: BillboardAd?
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case setDone(index: Int)
        case setUndone(index: Int)
        case addHabitTapped
        case showNotificationsTapped
        case habit(id: UUID, action: HabitFeature.Action)
        case showDetail(Habit)
        case showExampleDetail
        case fetchHabits
        case showNotificationsSettingsAreOff
        case synchronizeNotifications(Habit)
        case settingsView(SettingsFeature.Action)
        case didTapPremiumButton
        case checkIfSubscribed
        case setShowPlusButton(Bool)
        case fetchAdvertisement
        case didFetchAdvertisement(BillboardAd)
        case showEmptyViewState(Bool)
        case delegate(Delegate)
        
        enum Delegate {
            case inDetail(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .setShowPlusButton(let subscribed):
                
                state.isSubscribed = subscribed
                
                return .none
                
            case .checkIfSubscribed:
                
                return .run { send in
                    
                    let productsResult = await self.appStoreClient.subscriptionOptions()
                    
                    if let product = productsResult.products?.first(where: {$0.id == ProductIdStorage.AutoRenewableSubscriptionIdentifier.habicolorPlusMonthlyID.rawValue}) {
                        
                        guard let subscribed = await appStoreClient.isSubscribed(product).0 else { return }
                        
                        await send(.setShowPlusButton(subscribed), animation: .easeInOut)
                    }
                }
                
            case .didTapPremiumButton:
                
                HapticFeedbackManager.notification(type: .success)
                
                state.destination = .subscriptionView(SubscriptionFeature.State.init())
                
                return .none
                
            case .synchronizeNotifications(let habit):
                
                let notifications = NotificationInfoConverter.convert(
                    category: habit.id,
                    notifications: habit.notifications
                )
                
                return .run { [notifications] send in
                    
                    await LocalNotificationConfigurator.addNotificationsLocalNotifications(notifications)
                }
                
            case .fetchHabits:
                
                if let habits = client.all().data {
                    let habitsSorted = habits.sorted(by: {$0.getLastLogTimeToday() ?? Date() > $1.getLastLogTimeToday() ?? Date() })
                    state.habits = IdentifiedArray(uniqueElements: habitsSorted.map({HabitFeature.State(habit: $0)}))
                }
                
                if state.habits.isEmpty && !AppSettingsProvider.shared.didDeleteExample {
                    state.habits = [HabitFeature.State(habit: .example)]
                }
                
                return .run { [habits = state.habits] send in
                    
                    await send(.showEmptyViewState(habits.isEmpty))
                }
                
                
            case .destination(.presented(.subscriptionView(.didPurchaseProduct))):
                
                return .run { send in
                    
                    await send(.checkIfSubscribed)
                }
                
                
            case .addHabitTapped:
                
                if !state.isSubscribed && state.habits.count >= 2 {
                    state.destination = .alert(.showNeedsSubscription)
                } else {
                    
                    state.destination = .addHabitForm(AddHabitFeature.State(habitId: nil))
                }
                
                return .none
                
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.habitUpdated(habit))))):
                
                guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none }
                
                let id = state.habits[index].habit.id
                
                if let updatedHabit = client.updateHabit(habit, id).data {
                    
                    state.habits[index].habit = updatedHabit
                }
                
                return .run { [habit] send in
                    
                    await send(.synchronizeNotifications(habit))
                }
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.didTapNotficaitions(habit))))):
                
                state.path.append(HabitListFeature.Path.State.notificationsList(NotificationsListFeature.State(habits: [habit], predicate: nil)))
                
                
                return .none
                
            case let .path(.element(id: _, action: .habitDetail(.delegate(.confirmDeletion(habit))))):
                
                // example deletion
                if habit.id == Habit.example.id {
                    AppSettingsProvider.shared.didDeleteExample = true
                }
                
                if client.delete(habit).data == "SUCCESS" {
                    
                    guard let index = state.habits.firstIndex(where: {$0.habit.id == habit.id}) else { return .none }
                    
                    state.habits.remove(at: index)
                }
                
                return .run { [habit] _ in
                    await localNotificationsClient.deleteForCategory(habit.id.uuidString)
                }
                
            case let .destination(.presented(.addHabitForm(.delegate(.saveHabit(habit))))):
                
                if let habit = client.add(habit).data {
                    
                    AppAnalytics.logEvent(AnalyticsEvent(name: .didCreateHabit, value: habit.name))
                    
                    // delete example if there is any
                    if let index = state.habits.firstIndex(where: {$0.habit.id == Habit.example.id}) {
                        state.habits.remove(at: index)
                    }
                    
                    state.habits.insert(HabitFeature.State.init(habit: habit), at: 0)
                    
                    return .run { [self, habit] send in
                        
                        let notifcationSettings = await notificationHelper.askUserToAllowNotifications()
                        
                        if !notifcationSettings.didAccept && !habit.notifications.isEmpty && !self.disableNotificationAlert {
                            await send(.showNotificationsSettingsAreOff)
                        }
                        
                        if !habit.notifications.isEmpty  {
                            await send(.synchronizeNotifications(habit))
                        }
                        
                        await send(.showEmptyViewState(false), animation: .easeIn)
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
                    
                    if habit.id == Habit.example.id {
                        await send(.showExampleDetail)
                        return
                    }
                    
                    await send(.showDetail(habit))
                }
                
                
            case .showDetail(let habit):
                
                state.path.append(HabitListFeature.Path.State.habitDetail(HabitDetailFeature.State(habit: habit)))
                
                return .none
                
            case .showNotificationsTapped:
                
                let habits = state.habits.map {$0.habit}
                
                
                state.path.append(HabitListFeature.Path.State.notificationsList(NotificationsListFeature.State(habits: habits, predicate: nil)))
                
                return .none
                
            case .fetchAdvertisement:
                
                guard !state.isSubscribed else { return .none}
                
                return .run { send in
                    
                    await billBoardClient.showAdvertisement()
                    
                    guard let ad = billBoardClient.advertisement else { return }
                    await send(.didFetchAdvertisement(ad), animation: .easeIn)
                }
                
            case .didFetchAdvertisement(let ad):
                state.ad = ad
                return .none
                
                
            case .showNotificationsSettingsAreOff:
                
                state.destination = .alert(.pushSettingsDisabled)
                
                return .none
                
            case .showExampleDetail:
                
                state.path.append(HabitListFeature.Path.State.habitDetail(
                    HabitDetailFeature.State(
                        habit: .example,
                        contributionFeature: ContributionFeature.State(
                            habit: Habit.example.id,
                            previousWeeks: Contribution.generateAWholeYear()
                        ),
                        habitStatsFeature: HabitStatsFeature.State(
                            habit: .example
                        )
                    )
                )
                )
                
                return .none
                
            case .destination(.presented(.alert(.showHabiColorPlus))):
                
                return .run { send in
                    await send(.didTapPremiumButton)
                }
                
            case .showEmptyViewState(let showEmpty):
                
                state.showEmptyViewState = showEmpty
                
                return .none
                
            case .habit:
                
                return .none
                
            case .destination:
                return .none
                
            case .settingsView:
                
                return .none
                
            case .path:
                return .none
                
            case .delegate:
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
            case subscriptionView(SubscriptionFeature.State)
        }
        
        enum Action: Equatable {
            case addHabitForm(AddHabitFeature.Action)
            case alert(Alert)
            
            case subscriptionView(SubscriptionFeature.Action)
            
            enum Alert {
                case cancel
                case openSettings
                case dontShowAgain
                case showHabiColorPlus
            }
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: /State.addHabitForm, action: /Action.addHabitForm) {
                AddHabitFeature()
            }
            
            Scope(state: /State.subscriptionView, action: /Action.subscriptionView) {
                SubscriptionFeature(appStoreClient: StoreKitClient())
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
                NotificationsListFeature(localNotificationClient: .localCenter, notificationStorageSerice: .live)
            }
        }
    }
}

// MARK: ALERT DEFINITIONS

extension AlertState where Action == HabitListFeature.Destination.Action.Alert {
    
    static let pushSettingsDisabled = Self {
        TextState(trans("notifications_disable_alert_title"))
    } actions: {
        
        ButtonState(action: .openSettings) {
            TextState(trans("notification_disabled_alert_open_settings_option"))
        }
        
        ButtonState(role: .cancel, action: .cancel) {
            TextState(trans("notification_disabled_alert_ignore_option"))
        }
        
        ButtonState(role: .destructive, action: .dontShowAgain) {
            TextState(trans("notification_disabled_dont_show_again_option"))
        }
        
    } message: {
        TextState(trans("notification_disabled_alert_description"))
    }
}

extension AlertState where Action == HabitListFeature.Destination.Action.Alert {
    
    static let showNeedsSubscription = Self {
        TextState(trans("free_user_limitation_alert_title"))
    } actions: {
        
        ButtonState(action: .showHabiColorPlus) {
            TextState(trans("free_user_limitation_alert_show_subscription_title"))
        }
        
        ButtonState(role: .cancel, action: .cancel) {
            TextState(String.transStandards(for: .defaultCloseLabel))
        }
        
    } message: {
        TextState(trans("free_user_limitation_alert_description"))
    }
}
