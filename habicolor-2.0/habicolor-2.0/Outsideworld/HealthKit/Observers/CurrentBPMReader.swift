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
    
    func read() async throws -> Bpm{
        let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bpm, Error>) in
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
                        let date = Date(timeIntervalSince1970: heartRateSample.endDate.timeIntervalSince1970)
                        continuation.resume(returning: (Bpm(data: heartRate.description, date: date)))
                    } else {
                        continuation.resume(throwing: CurrentBPMError.unknownError)
                    }
                }
                
                self.healthStore.execute(query)
            }
        }
    }
}
