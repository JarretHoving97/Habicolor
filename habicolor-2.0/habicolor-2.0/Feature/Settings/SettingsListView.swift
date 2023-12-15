//
//  SettingsListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsListView: View {
    
    let store: StoreOf<SettingsFeature>

    var body: some View {
        WithViewStore(self.store, observe: \.menuItems) { viewStore in
            List {
                ForEach(Array(viewStore.keys).sorted(by: {$0 < $1}), id: \.self) { value in
                    Section(value) {
                        ForEach(viewStore[value] ?? [], id: \.self) { option in
                            
                            switch option.type {
                                
                            case .normal(let icon):
                                SettingsItemView(title: option.title, systemIcon: icon, action: {})
                                    .listRowBackground(Color.cardColor)
                                
                    
                            case .toggle:

                                SettingsSwitchView(title: option.title)
                                    .listRowBackground(Color.cardColor)
                            }
                        }
                    }
                }
            }
        
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.large)
            .background(Color.appBackgroundColor)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    SettingsListView(
        store: Store(
            initialState: SettingsFeature.State(
                menuItems: SettingsMenuModel.menu
            ),
            reducer: { SettingsFeature() }
        )
    )
}
