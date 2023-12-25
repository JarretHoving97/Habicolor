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
        
        var prefferedColorScheme: String = ""
        var hapticFeebackEnabled: Bool
        var colorSchemeImage: String = "moon.fill"
        
        var showRestorePurchaseLoading: Bool = false
        
        init() {
            self.prefferedColorScheme = AppSettingsProvider.shared.userPrefferedColorScheme
            self.hapticFeebackEnabled = AppSettingsProvider.shared.hapticFeedbackEnabled
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
        case didTapSocials
        
        case didTapUpgradeButton
        
        case destination(PresentationAction<Destination.Action>)
        
        case showRestorePurchaseLoading(Bool)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
                
            case .destination(.presented(.alert(.personalTapped))):
                
                guard let url = URL(string: "https://twitter.com/DevJarret") else { return .none}
                UIApplication.shared.open(url)
                
                return .none
                
            case .destination(.presented(.alert(.buisinessTapped))):
                
                guard let url = URL(string: "https://twitter.com/HabiColorApp") else { return .none}
                UIApplication.shared.open(url)
                
                return .none
                
                
            case .didTapSocials:
                
                HapticFeedbackManager.notification(type: .success)
                
                state.destination = .alert(.socials)
                
                return .none
                
            case .showRestorePurchaseLoading(let showLoading):
                
                state.showRestorePurchaseLoading = showLoading
                
                return .none
                
                
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
                
                HapticFeedbackManager.selection()
                
                return .run { send in
                    
                    await send(.showRestorePurchaseLoading(true), animation: .easeIn)
                    do {
                        try await AppStore.sync()
                        await send(.showRestorePurchaseLoading(false), animation: .easeIn)
                        debugPrint("redeemStoreKitPurchases Succeed Restored Purchases.")
                    } catch {
                        await send(.showRestorePurchaseLoading(false), animation: .easeIn)
                        // TODO: Show alert that something has been wrong.
                        debugPrint("redeemStoreKitPurchases Failed Restored Purchases.")
                    }
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
            case alert(ConfirmationDialogState<Action.Alert>)
        }
        
        
        enum Action: Equatable {
            case subscribeView(SubscriptionFeature.Action)
            case alert(Alert)
            
            enum Alert {
                case personalTapped
                case buisinessTapped
                case cancelTapped
            }
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

// MARK: ALERT DEFINITIONS
extension ConfirmationDialogState where Action == SettingsFeature.Destination.Action.Alert {
    
    static let socials = Self {
        TextState("Socials") // TODO: Translations
    } actions: {
        
        ButtonState(action: .buisinessTapped) {
            TextState("Habicolor X") // TODO: Translations
        }
        
        ButtonState(action: .personalTapped) {
            TextState("Personal X") // TODO: Translations
        }
        
        ButtonState(role: .cancel, action: .cancelTapped) {
            TextState("Close") // TODO: Translations
        }
    }
}
