//
//  HealthRequest.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 16/01/2024.
//

import Foundation
import HealthKit


protocol HealthKitRequest {
    
    var options: Set<HKSampleType> { get }
    
    func request() async throws
}

struct ReadHealthPermissionRequest: HealthKitRequest {
    
    private let store = HKHealthStore()
    
    var options: Set<HKSampleType>
    
    func request() async throws {
        try await store.requestAuthorization(toShare: [], read: options)
    }
}


