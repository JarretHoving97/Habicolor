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
    
    var options: Set<HKSampleType> {
        
        Set(
            [
                HKObjectType.workoutType(),
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
            ]
        )
    }
    
    func request() async throws {
        try await store.requestAuthorization(toShare: [], read: options)
    }
}




