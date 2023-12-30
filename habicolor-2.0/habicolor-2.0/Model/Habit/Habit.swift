//
//  Habit.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import CoreData
import Foundation

struct Habit: Hashable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let color: Color
    var weekGoal: Int
    let notifications: [Reminder]
    let createdAt: Date
    
    init(id: UUID, name: String, weekGoal: Int, description: String, color: Color, notifications: [Reminder]) {
        self.id = id
        self.name = name
        self.description = description
        self.weekGoal = weekGoal
        self.color = color
        self.notifications = notifications
        self.createdAt = Date()
    }
    
    init(nsHabit: NSHabit) {
        self.id = nsHabit.id!
        self.name = nsHabit.name ?? ""
        self.description = nsHabit.userDescription ?? ""
        self.color = Color(uiColor: UIColor(Color(hex: nsHabit.color ?? "")))
        self.weekGoal = Int(nsHabit.weekGoal)
        self.notifications = nsHabit.reminders?.map { Reminder($0 as! NSReminder) } ?? []
        self.createdAt = nsHabit.createdAt ?? Date()
    }
}


extension Habit {
    
    func getLastLogTimeToday() -> Date? {
        let client: LogClient = .live
        let result = client.find(id, Date().startOfDay).data
        return result?.logDate
    }
}

// MARK: Dummy Collection
extension Habit {
    
    static var example: Habit {
        return Habit(
            id: .staticShared,
            name: "🏃‍♂️ Example", // TODO: Translations
            weekGoal: 7,
            description: "See here a random example for how a habit could look like", // TODO: Translations
            color: .primaryColor,
            notifications: [
                Reminder(
                    id: UUID(),
                    days: [
                        .monday,
                        .tuesday,
                        .wednessday,
                        .thursday,
                        .friday,
                        .saturday,
                        .sunday
                    ],
                    time: Date(),
                    title: "It's time to get to work!",
                    description: "💪"
                ),
            ]
        )
    }
    
    static var staticContent: [Habit] {
        
        return [
            Habit(
                id: .staticShared,
                name: "🏋🏽‍♀️ Go to the gym",
                weekGoal: 7,
                description: "Regular gym sessions three times a week contribute to improved cardiovascular health, increased muscle strength, and enhanced flexibility. This consistent exercise routine helps manage weight, reduces the risk of chronic diseases, and boosts overall mental well-being by releasing endorphins. Committing to a thrice-weekly gym routine is a proactive step toward achieving and maintaining a healthy and balanced lifestyle.",
                color: .green,
                notifications: [
                    Reminder(
                        id: UUID(),
                        days: [
                            .monday,
                            .wednessday,
                            .sunday
                        ],
                        time: Date(),
                        title: "Gym boi",
                        description: "Let's go gym boi, on to the gym today 💪"
                    )
                ]
            ),
            
            Habit(
                id: UUID(),
                name: "🚫 Quit smoking",
                weekGoal: 6,
                description: "Smoking is detrimental to your health, increasing the risk of various diseases, including lung cancer, heart disease, and respiratory disorders. The harmful chemicals in cigarettes not only damage your lungs but also affect your overall well-being, leading to a shorter and less healthy life. Quitting smoking is one of the most impactful choices you can make for your long-term health and quality of life.",
                color: .purple,
                notifications: [
                    Reminder(
                        id: UUID(),
                        days: [
                            .monday,
                            .tuesday,
                            .wednessday,
                            .thursday,
                            .friday,
                            .saturday,
                            .sunday
                        ],
                        time: Date(),
                        title: "Time to drink son!!",
                        description: "Learn to drink Yerba Mate, so it will be better everyday"
                    ),
                ]
            ),
            
            
            Habit(
                id: UUID(),
                name: "💧 Drink water",
                weekGoal: 7,
                description: "Adequate water intake is crucial for maintaining overall health as it supports essential bodily functions such as digestion, nutrient absorption, and temperature regulation. Staying hydrated helps prevent dehydration, which can lead to fatigue, headaches, and impaired cognitive function. Make a habit of drinking enough water daily to promote optimal physical and mental well-being.",
                color: .green,
                notifications: [
                    Reminder(
                        id: UUID(),
                        days: [
                            .monday,
                            .wednessday,
                            .sunday
                        ],
                        time: Date(),
                        title: "Water time!",
                        description: "Let's get hydrated!!"
                    )
                ]
            ),
        ]
    }
}

extension UUID {
    static let staticShared = UUID()
}
