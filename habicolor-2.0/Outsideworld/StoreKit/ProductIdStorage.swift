//
//  ProductInfo.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation

/// Storage where you can add / find all products id's
class ProductIdStorage {
    
    static let sharedProductInfo = ProductIdStorage()
    
    enum AutoRenewableSubscriptionIdentifier: String, CaseIterable {
        
        case habicolorPlusMonthlyID = "nl.habicolor.plus.subscription.monthly"
    }
}
