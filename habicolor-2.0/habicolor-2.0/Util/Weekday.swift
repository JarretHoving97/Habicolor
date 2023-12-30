//
//  Weekday.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import Foundation

enum WeekDay: Int, CaseIterable, Hashable {
    
    case sunday = 1
    case monday
    case tuesday
    case wednessday
    case thursday
    case friday
    case saturday
}

extension WeekDay {
    
    var localizedString: String {
        return DateComponents.getWeekDayName(from: self.rawValue) ?? ""
     }
}
