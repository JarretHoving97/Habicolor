//
//  Weekday.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuesday
    case wednessday
    case thursday
    case friday
    case saturday
    case sunday
}

extension WeekDay {
    
    var localizedString:  String {
        
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednessday:
            return "Wednessday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
     }
}
