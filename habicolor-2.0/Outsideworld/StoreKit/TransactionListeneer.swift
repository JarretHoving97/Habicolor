//
//  TransactionListeneer.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import StoreKit

protocol TranactionsStatusObservable {
    func didFoundPurchaseUpdate(for product: String, isValid: Bool)
}

// Responsible for listening to Transaction updates.
// Without it risks missing successful pruchases.
class TransactionListeneer {
    
    var delegate: TranactionsStatusObservable?
    
    var updateListeneerTask: Task<Void, Error>?
    
    init() {
    
        // Iterate through any transactions which didn't come from a direct call to `purchase()`.
        self.updateListeneerTask = Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try TransactionVerifier.checkVerified(result)
                    
                    // Deliver content to the user.
                    await self.updatePurchasedIdentifiers(transaction)
                    
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    Log.error("Transaction failed verification")
                }
            }
        }
    }
}


extension TransactionListeneer {
    
    // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
    func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        delegate?.didFoundPurchaseUpdate(for: transaction.productID, isValid: transaction.revocationDate == nil)
    }
}
