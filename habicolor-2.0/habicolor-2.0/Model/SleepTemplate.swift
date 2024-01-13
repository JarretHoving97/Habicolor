//
//  SleepTemplate.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 10/01/2024.
//

import Foundation
import SwiftUI

struct SleepTemplate: HealthPresentable {
    
    var template: HealthCase
    
    init(template: HealthCase.SleepCase) {
        self.template = .sleep(template)
    }
    
    var icon: Image {
        Image(systemName: "bed.double.fill")
            .resizable()
    }
    
    var title: String {
        // TODO: Translations
        "Sleep"
    }
    
    var color: Color {
        Color("health_sleep_template")
    }
    
    func currentState() -> String {
        // TODO: Health Logic
        "6.5 Hours Sleep"
    }
}
