//
//  HabitListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 08/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct HabitListView: View {
    
    let store: StoreOf<HabitListFeature>
    
    var body: some View {
        
        NavigationStackStore(
            self.store.scope(
                state: \.path,
                action: {.path($0)})
        ) {
            WithViewStore(self.store, observe: \.habits) { viewStore in
                ScrollView {
                    VStack(spacing: 10) {
                        
                        ForEachStore(
                            self.store.scope(state: \.habits,
                                             action: HabitListFeature.Action.habit(id:action:))
                        ){
                            
                            HabitView(store: $0)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                
                                viewStore.send(.addHabitTapped)
                            } label: {
                                Label("Add New habit", systemImage: "pencil.tip.crop.circle.badge.plus")
                            }
                            
                            Divider()
                            
                            Button {
                                viewStore.send(.showNotificationsTapped)
                            } label: {
                                Label("Notifications", systemImage: "bell.badge")
                            }
                            
                            Button {
                                
                            } label: {
                                Label("Settings", systemImage: "gear")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                               
                        }
                    }
                }
                .background(Color.appBackgroundColor)
                
            }
        } destination: {
            switch $0 {
                
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
    }
}

#Preview {
    HabitListView(store: Store(
        initialState: HabitListFeature.State(habits: Habit.staticContent),
        reducer: { HabitListFeature(client: .live) }
    ))
}
