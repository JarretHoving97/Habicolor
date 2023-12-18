//
//  ProductInfo.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import Foundation

class ProductInfo {
    
    static let sharedProductInfo = ProductInfo()
    
    enum AutoRenewableSubscriptionIdentifier: String, CaseIterable {
        case habicolorPlusMonthlyID = "nl.habicolor.plus.subscription.monthly"
    }
}
