//
//  DateComponents+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/12/2023.
//

import Foundation

extension DateComponents {
    
    static func getWeekDayName(from weekday: Int) -> String? {
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        
        let dateFormatter = DateFormatter()
        
        // Set the date format to show the weekday symbol
        dateFormatter.dateFormat = "EEEE"
        
        // Get the date corresponding to the current weekday index
        if let date = Calendar.current.date(bySetting: .weekday, value: weekday, of: Date()) {
            // Get the weekday symbol from the formatted date
            let weekdayName = dateFormatter.string(from: date)
            
            // Add the weekday name to the array
            return weekdayName
        }
        
        return nil
    }
}

