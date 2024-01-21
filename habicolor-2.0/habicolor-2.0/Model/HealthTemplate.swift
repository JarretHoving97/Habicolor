//
//  HealthTemplate.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 13/01/2024.
//

import Foundation
import SwiftUI


struct HealthTemplate: HealthPresentable {
    
    var template: HealthCase
    
    var icon: Image {
        switch template {
            
        case .fysical:
            return Image(systemName: "figure")
            
        case .vital:
            return Image(systemName: "heart.fill")
            
        case .sleep:
            return Image(systemName: "bed.double.fill")
            
        case .none:
            return Image(systemName: "circle.fill")
        }
    }
    
    var title: String {
        // TODO:
        switch template {
        case .fysical(let fysicalCase):
            
            switch fysicalCase {
                
            case .steps:
                return "Steps"
            case .distance:
                return "Distance"
            case .calories:
                return "Calories"
            }
            
        case .vital(let vitalCase):
            
            switch vitalCase {
                
            case .bpm(let value):
                return "\(value) BPM" // TODO: Translations
                
            case .walkingBpm:
                return "Walking BPM"
            }
            
        case .sleep(let sleepCase):
            switch sleepCase {
                
            case .hoursOfSleep:
                return "Hours of sleep"
            }
            
        case .none:
            return "Regular"
        }
    }
    
    var textTint: Color {
        
        switch template {
            
        case .fysical:
            return Color("physical_red") // todo: Gradient
            
        case .vital:
            return Color("no_health_template_icon")
            
        case .sleep:
            return Color("health_sleep_template")
            
        case .none:
            return Color("no_health_template_icon")
            
        }
    }
    
    var imageTint: Color {
        
        switch template {
            
        case .fysical:
            return Color("physical_red") // todo: Gradient
            
        case .vital:
            return Color("vital_heart_color")
            
        case .sleep:
            return Color("health_sleep_template")
            
        case .none:
            return Color("no_health_template_icon")
            
        }
    }
}
