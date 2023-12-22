//
//  SettingsFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 15/12/2023.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct SettingsFeature: Reducer {

    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        
        var prefferedColorScheme: String = "System"
        var hapticFeebackEnabled: Bool
        var colorSchemeImage: String
        
        init() {
            self.prefferedColorScheme = AppSettingsProvider.shared.userPrefferedColorScheme
            self.hapticFeebackEnabled = AppSettingsProvider.shared.hapticFeedbackEnabled
            self.colorSchemeImage =  SystemThemeObserver.getSystemTheme() == .dark ? "moon.fill" : "sun.min.fill"
        }
    }
    
    enum Action: Equatable {
        case didToggleHapticFeedback(Bool)
        case setColorScheme(String)
        case configureSettingsInfo
        case configureColorSchemeImage
        case reviewButtonTapped
        case termsOfUseTapped
        case didTapReleaseNotes
        case didTapRestorePurchaseButton
        
        case didTapUpgradeButton
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .didTapReleaseNotes:
                
                guard let url = URL(string: "https://feather-opinion-8b6.notion.site/Habicolor-81e578a9a10643da884b8d40bd8d0e25") else { return .none }
                
                UIApplication.shared.open(url)
                
                return .none
                
            case .termsOfUseTapped:
                
                UIApplication.shared.open(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                
                return .none
                
            case .reviewButtonTapped:
                
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                
                return .none
                
            case .configureColorSchemeImage:
                
                if state.prefferedColorScheme == "System" {
            
                    state.colorSchemeImage = SystemThemeObserver.getSystemTheme() == .dark ? "moon.fill" : "sun.min.fill"
                    
                } else {
                    state.colorSchemeImage = state.prefferedColorScheme == "Light" ? "sun.min.fill" : "moon.fill"
                }
                
                return .none
                
            case .configureSettingsInfo:
                
                state.prefferedColorScheme = AppSettingsProvider.shared.userPrefferedColorScheme
                state.hapticFeebackEnabled = AppSettingsProvider.shared.hapticFeedbackEnabled
                
                return .none
                
                
            case .setColorScheme(let scheme):
                
                AppSettingsProvider.shared.userPrefferedColorScheme = scheme
                
                state.prefferedColorScheme = scheme
                
                HapticFeedbackManager.impact(style: .rigid)
                
                return .none
                
            case .didToggleHapticFeedback(let bool):
                
                state.hapticFeebackEnabled = bool
                AppSettingsProvider.shared.hapticFeedbackEnabled = bool
                
                return .none
                
                
            case .destination:
                
                return .none

                
            case .didTapRestorePurchaseButton:
                

                return .run { send in
                    
                    try? await AppStore.sync()
                }
                
            
            case .didTapUpgradeButton:
                
                HapticFeedbackManager.notification(type: .success)
                state.destination = .subscribeView(SubscriptionFeature.State())
                
                return .none
            }
            
            
        }
        
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        
        .onChange(of: \.prefferedColorScheme) { oldValue, newValue in
            Reduce { state, action in
                .send(.configureColorSchemeImage)
            }
        }
    }
}

extension SettingsFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case subscribeView(SubscriptionFeature.State)
        }
        
        
        enum Action: Equatable {
            case subscribeView(SubscriptionFeature.Action)
        }
    
        var body: some Reducer<State, Action> {
            
            Scope(state: /State.subscribeView, action: /Action.subscribeView) {
                SubscriptionFeature(appStoreClient: StoreKitClient())
            }
            
            Reduce { state, action in
                
                return .none
            }
        }
    }
}
