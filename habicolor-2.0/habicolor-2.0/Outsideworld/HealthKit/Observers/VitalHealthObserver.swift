//
//  VitalHealthObserver.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 17/01/2024.
//

import Foundation
import HealthKit

class VitalHealthObserver {
    
    let bpmReader: CurrentHearthBPMReadable
    
    init(bpmReader: CurrentHearthBPMReadable) {
        self.bpmReader = bpmReader
    }
}



