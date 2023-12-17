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
        WithViewStore(self.store, observe: {$0}) { viewStore in
            List {
        
                Section("extra") {
                    SettingsItemView(title: "Upgrade to Plus", systemIcon: "plus.app") {
                        
                    }
                    .listRowBackground(Color.cardColor)
                    
                    SettingsItemView(title: "Release notes", systemIcon: "book.pages") {
                    }
                    .listRowBackground(Color.cardColor)
                    
                    SettingsItemView(title: "Review",
                                     systemIcon: "heart.fill") {
                        
                    }
                     .listRowBackground(Color.cardColor)
                }
                
                Section("App") {
                    SettingsSwitchView(
                        title: "Haptic Feedback",
                        systemIcon: "water.waves",
                        enabled: viewStore.binding(
                            get: \.hapticFeebackEnabled,
                            send: SettingsFeature.Action.didToggleHapticFeedback
                        )
                    )
                    .listRowBackground(Color.cardColor)

                    
                    SettingsPickerView(title: "Color Scheme",
                                       systemIcon: "moon.fill", selection: viewStore.binding(
                                        get: \.prefferedColorScheme,
                                        send: SettingsFeature.Action.setColorScheme),
                                       options: ["System", "Light", "Dark"])
                    
                    .listRowBackground(Color.cardColor)

                }
                
                Section("about") {
                    
                    SettingsItemView(title: "Mail", systemIcon: "envelope.fill") {
                    }
                    .listRowBackground(Color.cardColor)
                    
                    SettingsItemView(title: "Socials", systemIcon: "person.2") {
                        
                    }
                    .listRowBackground(Color.cardColor)
                    
                    SettingsItemView(title: "Terms of Use", systemIcon: "doc.text") {
                    }
                    .listRowBackground(Color.cardColor)
                    
                    SettingsItemView(title: "Privacy Policy", systemIcon: "hand.raised.square") {
                    }
                    .listRowBackground(Color.cardColor)
                    
                }
            }
        
            .navigationTitle("Settings") // TODO: Translations
            .toolbarTitleDisplayMode(.large)
            .background(Color.appBackgroundColor)
            .scrollContentBackground(.hidden)
            
            .onAppear {
                viewStore.send(.configureSettingsInfo)
            }
        }
    }
}

#Preview {
    SettingsListView(
        store: Store(
            initialState: SettingsFeature.State(),
            reducer: { SettingsFeature() }
        )
    )
}
