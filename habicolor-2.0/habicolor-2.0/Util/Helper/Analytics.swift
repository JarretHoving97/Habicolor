//
//  Analytics.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 28/12/2023.
//

import Foundation
import FirebaseAnalytics

class AppAnalytics {

    static func logEvent(_ event: AnalyticsEvent) {
        // Increment event
        Log.event(event.name)
        let count = incrementEventCount(event: event.name)
        
        Log.event("you have done \(event.name) \(count) times")
        
        if let paramValue = event.value {
            Analytics.logEvent(event.name, parameters: ["label": paramValue])
        } else {
            Analytics.logEvent(event.name, parameters: nil)
        }
    }

    static func incrementEventCount(event: String) -> Int {
        var dict: [String: Int] = (UserDefaults.standard.dictionary(forKey: "AppAnalytics") as? [String: Int]) ?? [:]
        let count: Int = dict[event, default: 0]
        dict[event] = count + 1

        UserDefaults.standard.set(dict, forKey: "AppAnalytics")
        UserDefaults.standard.synchronize()
        return count + 1
    }
}

struct AnalyticsEvent {
    
    let name: String
    let value: String?
    
    init(name: AnalyticsEventName, value: String?) {
        self.name = name.rawValue
        self.value = value
    }
    
    enum AnalyticsEventName: String {
        case didLaunch = "did_lauch_app"
        case didCreateHabit = "did_create_habit"
    }
}
