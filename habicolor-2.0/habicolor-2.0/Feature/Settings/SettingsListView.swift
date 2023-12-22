//
//  SettingsListView.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct SettingsListView: View {
    
    let store: StoreOf<SettingsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            List {
                Section("extra") {
                    // TODO: Translations
                    SettingsItemView(title: "Upgrade", systemIcon: "arrowshape.up.fill", action: {
                        viewStore.send(.didTapUpgradeButton)
                    })
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())

                    // TODO: Translations
                    SettingsItemProgressView(
                        title: "Restore purchase",
                        systemIcon: "arrow.triangle.2.circlepath",
                        action: {
                            viewStore.send(.didTapRestorePurchaseButton)
                        },
                        showIndicator: viewStore.binding(
                            get: \.showRestorePurchaseLoading,
                            send: SettingsFeature.Action.showRestorePurchaseLoading
                        )
                    )
                    
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    // TODO: Translations
                    SettingsItemView(title: "Release notes", systemIcon: "book.pages") {
                        viewStore.send(.didTapReleaseNotes)
                    }
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    // TODO: Translations
                    SettingsItemView(title: "Review", systemIcon: "heart.fill") {
                        viewStore.send(.reviewButtonTapped)
                    }
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Section {
                    // TODO: Translations
                    SettingsPickerView(title: "Color Scheme",
                                       systemIcon: viewStore.colorSchemeImage,
                                       selection: viewStore.binding(
                                        get: \.prefferedColorScheme,
                                        send: SettingsFeature.Action.setColorScheme),
                                       options: ["System", "Light", "Dark"])
                    
                    .listRowBackground(Color.cardColor)
                    
                    // TODO: Translations
                    SettingsSwitchView(
                        title: "Haptic Feedback",
                        systemIcon: "water.waves",
                        enabled: viewStore.binding(
                            get: \.hapticFeebackEnabled,
                            send: SettingsFeature.Action.didToggleHapticFeedback
                        )
                    )
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    
                } header: {
                    Text("App")
                
                } footer: {
                    // TODO: Translations
                    Text("Haptic feedback will automatically be disabled if your device is low on battery.")
                }

                // TODO: Translations
                Section("about") {
                    // TODO: Translations
                    SettingsItemView(title: "Mail", systemIcon: "envelope.fill") {}
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    // TODO: Translations
                    SettingsItemView(title: "Socials", systemIcon: "person.2") { /* TODO: Open action alert */ }
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    // TODO: Translations
                    SettingsItemView(title: "Terms of Use", systemIcon: "doc.text") { viewStore.send(.termsOfUseTapped) }
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                    // TODO: Translations
                    SettingsItemView(title: "Privacy Policy", systemIcon: "hand.raised.square") {}
                    .listRowBackground(Color.cardColor)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            .sheet(
                store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                state: /SettingsFeature.Destination.State.subscribeView,
                action: SettingsFeature.Destination.Action.subscribeView
            ) { store in
                SubscribeView(store: store)
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
