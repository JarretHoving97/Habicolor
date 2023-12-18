//
//  StoreKitProvider.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import StoreKit

public enum StoreError: Error, Equatable {
    case failedFetchingProducts
    case failedGettingProductStatus
    case failedToPurchase
    case failedVerification
}

typealias StoreKitResults = (products: [Product]?, error: Error?)
typealias StoreKitIsSubscribedResult = (didPurchase: Bool?, error: Error?)

class StoreKitProvider {
    
    static let live = StoreKitProvider()

    public func requestRenewableSubscriptions(identifiers: [String]) async -> StoreKitResults  {
        do {
            let products = try await Product.products(for: identifiers)
            let renewableProducts = products.filter({ .autoRenewable == $0.type ? true : false })
            return (renewableProducts, nil)
        } catch {
            Log.error("Could not fetch any products")
            return StoreKitResults(nil, StoreError.failedFetchingProducts)
        }
    }
    
    public func fetchIsSubscribed(for product: Product) async -> StoreKitIsSubscribedResult {
        do {
            let result = try await product.subscription?.status.contains(where: {$0.state == .subscribed})
            return (result, nil)
            
        } catch {
            return (nil, StoreError.failedGettingProductStatus)
        }
    }
    
    public func purchase(_ product: Product) async -> StoreKitIsSubscribedResult {
        do {
            
            let result = try await product.purchase()
            
            if case let .success(verificationResult) = result {
                
                let verifiedTransaction = try TransactionVerifier.checkVerified(verificationResult)
                
                // wait for the transaction to finish
                await verifiedTransaction.finish()
                
                return (true, nil)
            }
            
            // throw failed verification
            throw StoreError.failedToPurchase
            
        } catch {
            return (false, StoreError.failedToPurchase)
        }
    }
 }
