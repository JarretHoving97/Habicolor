//
//  MyCalendar.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//

import Foundation

final class MyCalendar {
    static let shared: MyCalendar = MyCalendar()
    var calendar: Calendar

    private init() {
        calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
    }
}
