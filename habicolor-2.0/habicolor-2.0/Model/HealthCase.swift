//
//  HealthCase.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import Foundation


enum HealthCase: Equatable {
    
    case fysical(FysicalCase)
    case vital(VitalCase)
    case sleep(SleepCase)
    case none
}

extension HealthCase {
    
    enum FysicalCase: Equatable {
        case steps(String)
        case distance(String)
        case calories(String)
    }
    
    enum VitalCase: Equatable {
        case bpm(String)
        case walkingBpm(String)
    }
    
    enum SleepCase: Equatable {
        case hoursOfSleep(String)
    }
}
