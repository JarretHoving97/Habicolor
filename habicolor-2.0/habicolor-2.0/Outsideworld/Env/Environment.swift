//
//  Environment.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 02/01/2024.
//

import Foundation


enum Environment: String {
    
    case test = "DEV"
    case beta = "BETA"
    case production = "PROD"
    
    // get key value from propertyfile
    static let environmentKey = "ENV"
    
    static var current: Environment = {
        let env = Bundle.main.object(forInfoDictionaryKey: environmentKey) as? String ?? ""
        return Environment(rawValue: env) ?? .production
    }()
}
