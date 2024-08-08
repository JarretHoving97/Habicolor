//
//  TransactionVerifier.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation
import StoreKit

class TransactionVerifier {
    //Check if the transaction passes StoreKit verification.
    static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
            
        case .verified(let safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }
}
