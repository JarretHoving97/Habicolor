//
//  SubscriptionFeature.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 17/12/2023.
//

import Foundation
import ComposableArchitecture
import StoreKit

struct SubscriptionFeature: Reducer {
    
    var appStoreClient: StoreKitClient
    
    struct State: Equatable {
        
        @PresentationState var destination: Destination.State?
        
        var productToPurchase: Product?
        var purchasedProduct: Product?
        var isPurchasing: Bool = false
    }
    
    enum Action: Equatable {
        case dismissTapped
        case fetchProducts
        case didFetchProducts([Product])
        case didPurchaseProduct(Product)
        case didReceiveError(StoreError)
        case didTapPurchaseProduct
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        
        case setIsLoading(Bool)
        
        
        enum ErrorAlert: Equatable {
            case dismiss
        }

        
        enum Delegate {
            case showSuccessPurchaseAlert
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .didFetchProducts(let products):
                
                state.productToPurchase = products.first(where: { $0.id == ProductIdStorage.AutoRenewableSubscriptionIdentifier.habicolorPlusMonthlyID.rawValue })
               
                return .none
                
            case .fetchProducts:
                
                return .run { send in
                    
                    let result = await self.appStoreClient.subscriptionOptions()

                    if let products = result.products {
                        await send(.didFetchProducts(products))
                        
                        return
                    }
                    
                    if let error = result.error {
                        await send(.didReceiveError(error as! StoreError))
                    } else {
                        // handle exception
                        await send(.didReceiveError(StoreError.failedToPurchase))
                    }
                }
                
            case .dismissTapped:
                
                HapticFeedbackManager.impact(style: .soft)
                
                return .run { _ in
                    
                    await self.dismiss()
                }
                
            case .didTapPurchaseProduct:
                // show loading
                guard let productToPurchase = state.productToPurchase else { return .none }
                
                return .run { [productToPurchase] send in
                    await send(.setIsLoading(true), animation: .easeIn)
                
                    let result = await self.appStoreClient.purchase(productToPurchase)
                    
                    if let result = result.didPurchase, result == true {
                        await send(.didPurchaseProduct(productToPurchase))
                        await send(.setIsLoading(false), animation: .easeOut)
                    }
                    
                    if let error = result.error, let storeError = error as? StoreError  {
                        await send(.didReceiveError(storeError))
                        await send(.setIsLoading(false), animation: .easeOut)
                    }
                }
                
            case .didPurchaseProduct(let product):
                
                state.purchasedProduct = product
                
                return .run { send in
                    
                    await send(.delegate(.showSuccessPurchaseAlert))
                    await self.dismiss()
                }
                
            case .didReceiveError(let error):
                
                let error = error as StoreError
                
                HapticFeedbackManager.notification(type: .error)
                
                state.destination = .alert(
                    AlertState {
                        TextState("Error found while purchasing product") // TODO: Translations
                    } actions: {
                        ButtonState(role: .none, action: .didDissmiss) {
                            TextState("Cancel") // TODO: Translations
                        }
                    } message: {
                        
                        switch error {
                        case .failedFetchingProducts:
                            return TextState("Could not load any products from the AppStore") // TODO: Translations
                            
                        case .failedGettingProductStatus:
                            return TextState("Could not get any status from the purchased product") // TODO: Translations
                            
                        case .failedToPurchase:
                            return TextState("Could not purchase product.") // TODO: Translations
                            
                        case .failedVerification:
                            return TextState("Product verification has failed") // TODO: Translations
                        }
                    }
                )
                
                return .none
                
            case .destination(.presented(.alert(.didDissmiss))):
                
                state.destination = nil
                state.isPurchasing = false
                
                return .none
                
            case .setIsLoading(let loading):
                
                state.isPurchasing = loading
                
                return .none
                
            case .delegate:
                
                return .none
                
            case .destination:
                
                return .none
            }
        }
    }
}


extension SubscriptionFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
        }
        
        enum Action: Equatable {
            
            case alert(Alert)
                       
            enum Alert {
                case didDissmiss
            }
        }
        
        var body: some Reducer<State, Action> {
            
            Reduce { state, action in
                
                return .none
            }
            
        }
    }
}
