//
//  Date+Extension.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 20/10/2023.
//


import Foundation

extension Date {
    
    func getString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar   = Calendar(identifier: .gregorian)
        formatter.timeZone   = TimeZone(identifier: "CET")
        formatter.locale     = Locale(identifier: "nl_NL")
        return formatter.string(from: self)
    }
    
    func getStringTranslated(format: String) -> String {
        let locale = Locale.current
        let userFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: locale)
        Log.debug("DATE \(userFormat ?? format)")
        let formatter = DateFormatter()
        formatter.dateFormat = userFormat ?? format
        formatter.calendar   = Calendar(identifier: .gregorian)
        formatter.timeZone   = TimeZone(identifier: "CET")
        formatter.locale     = locale
        return formatter.string(from: self)
    }
}

extension Date {
    
    /// The start of the day
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self).adding(1, .minute)!
    }
    
    public var endOfDay: Date {
        // Get the current calendar
        let calendar = Calendar.current

        // Get the components of the given date
        var components = calendar.dateComponents([.year, .month, .day], from: self)

        // Set the components for the end of the day
        components.hour = 23
        components.minute = 59
        components.second = 59

        // Create a new date with the modified components
        return calendar.date(from: components)!
    }
    
    
    /// start of week
    public var startOfWeek: Date {
        return MyCalendar.shared.calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    public var endOfWeek: Date {
        // Add 6 days (representing the end of the week)
        return MyCalendar.shared.calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    }
    
    /// The start of the next day
    public var startOfNextDay: Date {
        return startOfDay.addingTimeInterval(86400)
    }
    
    /// Returns a boolean if the date is in the past
    public var isInThePast: Bool {
        return Date() > self
    }
    
    /// Returns a boolean if the date is in the future
    public var isInTheFuture: Bool {
        return Date() < self
    }
    
    /// Returns a boolean if the date is yesterday
    public var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Returns a boolean if the date is today
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Returns a boolean if the date is tomorrow
    public var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    public func adding(_ value: Int, _ component: Calendar.Component) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    public func isInSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: component)
    }
    
    public func isInThis(_ component: Calendar.Component) -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: component)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Date {
    
    func getToDaysString() -> String {
        return getTodayWeekDay(format: .fullDateString)
    }
    
    func getTodayWeekDay(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let weekDay = dateFormatter.string(from: self)
        return weekDay.capitalized
    }
    
    func formatToDateString(with format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let weekDay = dateFormatter.string(from: self)
        return weekDay.capitalized
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM"
        let string = dateFormatter.string(from: self)
        return String(string.prefix(3))
    }
}


enum DateFormat: String {
    
    /// Woensdag
    case currentDay = "EEEE"
    
    /// Woe
    case currentDayShorted = "EEE"
    
    /// 12
    case currentMonthDayNumber = "dd"
    
    /// 12 juni 1997
    case fullDateWithMonthName = "dd MMMM yyyy"
    
    /// 12-06-1997
    case fullDateString = "dd-MM-yyyy"
    
    /// 12-06-1997 12:06
    case dateTime = "dd-MM-yyyy HH:mm:ss"
    
    ///  June
    case month = "MMMM"
    
    /// 12:06
    case time = "HH:mm"
    
    case dayMonth = "dd MMMM"
}
