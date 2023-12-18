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
        
        var productToPurchase: Product?
        var purchasedProduct: Product?
    }
    
    enum Action: Equatable {
        case dismissTapped
        case fetchProducts
    
        case didFetchProducts([Product])
        case didPurchaseProduct(Product)
        case didReceiveError(StoreError)
        case didTapPurchaseProduct
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
                
            case .didFetchProducts(let products):
                
                state.productToPurchase = products.first(where: {$0.id == ProductInfo.AutoRenewableSubscriptionIdentifier.habicolorPlusMonthlyID.rawValue})
               
                return .none
                
            case .fetchProducts:
                
                return .run { send in
                    
                    let result = await self.appStoreClient.subscriptionOptions()
                    
                    if let products = result.products {
                        await send(.didFetchProducts(products))
                    }
                    
                    if let error = result.error {
                        await send(.didReceiveError(error as! StoreError))
                    }
                }
                
            case .dismissTapped:
                
                HapticFeedbackManager.impact(style: .soft)
                
                return .run { _ in
                    
                    await self.dismiss()
                }
                
            case .didTapPurchaseProduct:
                // show loading
                guard let productToPurchase = state.productToPurchase else { return .none}
                
                return .run { [productToPurchase] send in
                    let result = await self.appStoreClient.purchase(productToPurchase)
                    
                    if let result = result.didPurchase, result == true {
                        await send(.didPurchaseProduct(productToPurchase))
                    }
                }
                
            case .didPurchaseProduct(let product):
                
                state.productToPurchase = product
                
                return .none
                
            case .didReceiveError(let error):
                guard let error = error as? StoreError else  { return .none }
                
//                switch error {
//                    
//                case .failedFetchingProducts:
//                    <#code#>
//                case .failedGettingProductStatus:
//                    <#code#>
//                case .failedToPurchase:
//                    <#code#>
//                case .failedVerification:
//                    <#code#>
//                }
                
                return .none
            }
        }
    }
}
