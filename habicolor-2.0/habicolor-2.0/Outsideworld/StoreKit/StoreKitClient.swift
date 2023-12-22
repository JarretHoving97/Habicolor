//
//  StoreKitClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import StoreKit

class StoreKitClient {
    
    /// fetch renewable subscriptions
    var subscriptionOptions: (() async -> StoreKitResults) = {
        await StoreKitProvider.live.requestRenewableSubscriptions(identifiers: ProductIdStorage.AutoRenewableSubscriptionIdentifier.allCases.map({$0.rawValue}) )
    }
    
    /// check if subscribed for a product
    func isSubscribed(_ product: Product) async -> StoreKitIsSubscribedResult {
        await StoreKitProvider.live.fetchIsSubscribed(for: product)
    }
    
    /// request a purchase to appstore connect
    func purchase(_ product: Product) async -> StoreKitIsSubscribedResult {
        await StoreKitProvider.live.purchase(product)
    }
}
