//
//  AppFeatureView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import ComposableArchitecture


struct AppFeatureView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: \.preferredColorScheme) { viewStore in
            
            TabBarView(store: Store(
                initialState: TabbarFeature.State(
                    currentTab: .habits, // init current selection
                    habitList: HabitListFeature.State(),
                    settings: SettingsFeature.State()
                ),
                /* add Log book initialization */
                reducer: { TabbarFeature()
                }
            )
            )
            
       
            //            TabView {
            //                HabitListView(
            //                    store: self.store.scope(
            //                        state: \.habitListFeature,
            //                        action: AppFeature.Action.habitListFeature
            //                    )
            //                )
            //                .tint(.appTextColor)
            //                .tabItem {
            //                    Image(systemName: "list.bullet")
            //                }
            //
            //                Text("Logbook")
            //                    .tabItem {
            //                        Image(systemName: "book.fill")
            //                    }
            //                    .tint(.appTextColor)
            //
            //
            //                SettingsListView(
            //                    store: self.store.scope(
            //                        state: \.settingsFeature,
            //                        action: AppFeature.Action.settingsFeature
            //                    )
            //                )
            //
            //                .tabItem {
            //                    Image(systemName: "gearshape.fill")
            //                }
            //            }
            //
            //            .preferredColorScheme(viewStore.state)
            //            .tint(.sparkleColor)
        }
    }
}

#Preview {
    AppFeatureView(
        store: Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    )
}
