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
            ZStack {
                List {
                    Section(trans("settings_view_extra_section_title_label")) {
                        
                        SettingsItemView(title: trans("settings_view_review_title_label"), systemIcon: "heart.fill") {
                            viewStore.send(.reviewButtonTapped)
                        }
                        .listRowBackground(Color.cardColor)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsItemView(title: trans("settings_view_release_notes_label"), systemIcon: "book.pages") {
                            viewStore.send(.didTapReleaseNotes)
                        }
                        .listRowBackground(Color.cardColor)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsItemView(title: trans("settings_view_upgrade_to_plus_label"), systemIcon: "arrowshape.up", action: {
                            viewStore.send(.didTapUpgradeButton)
                        })
                        .tint(Color("sparkle_color"))
                        .listRowBackground(Color.cardColor)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsItemProgressView(
                            title: trans("settings_view_restore_purchases_label"),
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
                    }
                    
                    Section {
                        
                        SettingsItemView(title: trans("lanugage_settings_button_label"), systemIcon: "globe") {
                            viewStore.send(.didTapLanguageButton)
                        }
                        .listRowBackground(Color.cardColor)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsPickerView(title: trans("settings_view_color_scheme_label"),
                                           systemIcon: viewStore.colorSchemeImage,
                                           selection: viewStore.binding(
                                            get: \.prefferedColorScheme,
                                            send: SettingsFeature.Action.setColorScheme),
                                           options: [
                                                trans("settings_view_color_scheme_option_0"),
                                                trans("settings_view_color_scheme_option_1"),
                                                trans("settings_view_color_scheme_option_2")
                                                ]
                                            )
                        
                        .listRowBackground(Color.cardColor)
                        
                        SettingsSwitchView(
                            title: trans("settings_view_haptic_feedback_label"),
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
                        Text(trans("settings_view_haptic_feedback_description"))
                    }
                    
                    Section {
                        
                        SettingsItemView(title: "Socials", systemIcon: "person.2") {
                            viewStore.send(.didTapSocials)
                        }
                        .listRowBackground(Color.cardColor)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsItemView(title: trans("settings_view_terms_of_use_label"), systemIcon: "doc.text") { viewStore.send(.termsOfUseTapped) }
                            .listRowBackground(Color.cardColor)
                            .buttonStyle(BorderlessButtonStyle())
                        
                        SettingsItemView(title: trans("settings_view_privacy_policy_label"), systemIcon: "hand.raised.square") { viewStore.send(.didTapPrivacyPolicy)}
                            .listRowBackground(Color.cardColor)
                            .buttonStyle(BorderlessButtonStyle())
                        
                        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            SettingsItemView(title: "v" + appVersion, systemIcon: "circle.fill") {}
                            .listRowBackground(Color.cardColor)
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(true)
                        }
                    
                        
                    } header: {
                        Text(trans("settings_view_about_section_title_label"))
                        
                    } footer: {
                        
                        Text(trans("settings_view_about_problems_description"))
                    }
                }
                
                .confirmationDialog(store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                                    state: /SettingsFeature.Destination.State.alert,
                                    action: SettingsFeature.Destination.Action.alert)
                .sheet(
                    store: self.store.scope(state: \.$destination, action: { .destination($0)}),
                    state: /SettingsFeature.Destination.State.subscribeView,
                    action: SettingsFeature.Destination.Action.subscribeView
                ) { store in
                    SubscribeView(store: store)
                }
                .navigationTitle(trans("settings_view_nav_title"))
                .toolbarTitleDisplayMode(.large)
                .background(Color.appBackgroundColor)
                .scrollContentBackground(.hidden)
                .onAppear {
                    viewStore.send(.configureSettingsInfo)
                    viewStore.send(.configureColorSchemeImage)
                }
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
