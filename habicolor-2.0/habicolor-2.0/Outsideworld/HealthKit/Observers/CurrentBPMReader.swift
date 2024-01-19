import Foundation
import HealthKit
import ComposableArchitecture

enum CurrentBPMError: Error {
    case unAuthorized
    case queryError(Error)
    case unknownError
}

class CurrentBPMReader: CurrentHearthBPMReadable {
    
    let healthStore = HKHealthStore()
    
    func read() async throws -> String {
        let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
                // return unAuthorized Error
                if error != nil {
                    continuation.resume(throwing: CurrentBPMError.unAuthorized)
                    return
                }
                
                let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                // load current
                let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                    // return any other query error
                    if let error = error {
                        continuation.resume(throwing: CurrentBPMError.queryError(error))
                        return
                    }
                    
                    if let heartRateSample = results?.first as? HKQuantitySample {
                        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                        let heartRate = Int(heartRateSample.quantity.doubleValue(for: heartRateUnit))
                        continuation.resume(returning: "\(heartRate)")
                    } else {
                        continuation.resume(throwing: CurrentBPMError.unknownError)
                    }
                }
                
                self.healthStore.execute(query)
            }
        }
    }
}
