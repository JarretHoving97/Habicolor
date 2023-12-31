//
//  HabitListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Billboard

struct HabitListView: View {
    
    let store: StoreOf<HabitListFeature>
    
    var body: some View {
        
        NavigationStackStore(
            self.store.scope(
                state: \.path,
                action: {.path($0)}))
        {
            WithViewStore(self.store, observe: {$0}) { viewStore in
                
                
                ScrollView {
                    
                    VStack(spacing: 10) {
                        
                        if !viewStore.showEmptyViewState {
                            ForEachStore(
                                self.store.scope(state: \.habits,
                                                 action: HabitListFeature.Action.habit(id:action:))
                            ){
                                HabitView(store: $0)
                            }
                        } else {
                            
                            VStack {
                                Text(trans("home_view_create_first_habit_title"))
                                    .themedFont(name: .medium, size: .title)
                                
                                Text(trans("home_view_create_first_habit_description"))
                                    .themedFont(name: .regular, size: .regular)
                                    .foregroundStyle(Color.appTextColor.opacity(0.4))
                                    .multilineTextAlignment(.center)
                                
                                
                                Divider()
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                        }
                        
                        
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                
                .safeAreaInset(edge: .bottom) {
                    if let ad = viewStore.ad, !viewStore.isSubscribed {
                        BillboardBannerView(advert: ad)
                            .padding()
                    }
                }
                
                .toolbar {
                    
                    ToolbarItem(placement: .principal) {
                        
                        Button {
                            viewStore.send(.didTapPremiumButton)
                            
                        } label: {
                            UpgradePremiumButton()
                        }
                        .opacity(viewStore.isSubscribed ? 0 : 1)
                        .disabled(viewStore.isSubscribed)
                        
                        .sheet(
                            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                            state: /HabitListFeature.Destination.State.subscriptionView,
                            action: HabitListFeature.Destination.Action.subscriptionView
                        ) { store in
                            SubscribeView(store: store)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                viewStore.send(.addHabitTapped)
                            } label: {
                                
                                Label(trans("home_view_menu_add_habit_button_title"), systemImage: "pencil.tip.crop.circle.badge.plus")
                            }
                            
                            Divider()
                            
                            Button {
                                viewStore.send(.showNotificationsTapped)
                            } label: {
                                
                                Label(trans("home_view_menu_notifications_button_title"), systemImage: "bell.badge")
                            }
                            
                            Button {
                                viewStore.send(.settingsTapped)
                            } label: {
                                
                                Label(trans("home_view_menu_settings_button_title"), systemImage: "gear")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
                .background(Color.appBackgroundColor)
                .navigationBarTitleDisplayMode(.inline)
                
                .task {
                    viewStore.send(.fetchHabits)
                    viewStore.send(.checkIfSubscribed)
                    viewStore.send(.fetchAdvertisement)
                }
            }
        } destination: {
            switch $0 {
                
            case .settingsList:
                CaseLet(
                    /HabitListFeature.Path.State.settingsList,
                     action: HabitListFeature.Path.Action.settingsList,
                     then: SettingsListView.init(store: ))
                
            case .habitDetail:
                CaseLet(
                    /HabitListFeature.Path.State.habitDetail,
                     action: HabitListFeature.Path.Action.habitDetail,
                     then: HabitDetailView.init(store:))
                
            case .notificationsList:
                CaseLet(
                    /HabitListFeature.Path.State.notificationsList,
                     action: HabitListFeature.Path.Action.notificationsList,
                     then: NotificationsListView.init(store:))
            }
        }
        .alert(
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitListFeature.Destination.State.alert,
            action: HabitListFeature.Destination.Action.alert
        )
        
        .sheet(
            
            store: self.store.scope(state: \.$destination, action: { .destination($0)}),
            state: /HabitListFeature.Destination.State.addHabitForm,
            action: HabitListFeature.Destination.Action.addHabitForm
        ) { store in
            AddHabitForm(store: store)
                .interactiveDismissDisabled()
        }
        .tint(Color("app_tint"))
    }
    
    
}

#Preview {
    HabitListView(store: Store(
        initialState: HabitListFeature.State(),
        reducer: { HabitListFeature(client: .live) }
    ))
}
