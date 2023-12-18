//
//  StoreKitClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import StoreKit


class StoreKitClient {
        
    var subscriptionOptions: (() async -> StoreKitResults) = {
        await StoreKitProvider.live.requestRenewableSubscriptions(identifiers: ProductInfo.AutoRenewableSubscriptionIdentifier.allCases.map({$0.rawValue}) )
    }
    
    func isSubscribed(_ product: Product) async -> StoreKitIsSubscribedResult {
        await StoreKitProvider.live.fetchIsSubscribed(for: product)
    }
    
    func purchase(_ product: Product) async -> StoreKitIsSubscribedResult {
        await StoreKitProvider.live.purchase(product)
    }
}
