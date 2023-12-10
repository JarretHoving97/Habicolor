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
    
    init(id: UUID, name: String, weekGoal: Int, description: String, color: Color, notifications: [Reminder]) {
        self.id = id
        self.name = name
        self.description = description
        self.weekGoal = weekGoal
        self.color = color
        self.notifications = notifications
    }
    
    init(nsHabit: NSHabit) {
        self.id = nsHabit.id!
        self.name = nsHabit.name ?? ""
        self.description = nsHabit.userDescription ?? ""
        self.color = Color(uiColor: UIColor(Color(hex: nsHabit.color ?? "")))
        self.weekGoal = Int(nsHabit.weekGoal)
        self.notifications = nsHabit.reminders?.map { Reminder($0 as! NSReminder) } ?? []
    }
}


// MARK: Dummy Collection
extension Habit {
    
    static var example: Habit {
        return Habit(
            id: UUID(),
            name: "Go to the gym",
            weekGoal: 5,
            description: "Get that body you want!",
            color: .pink,
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
                    title: "Quit smoking!",
                    description: "Try to quit smoking for today, everyday is a new day for success!"
                ),
            ])
    }
    
    static var staticContent: [Habit] {
        
        return [
            Habit(
                id: UUID(),
                name: "🚬 Quit smoking..",
                weekGoal: 2,
                description: "Smoking causes alot of health problems including different types of cancer.",
                color: .red,
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
                        title: "Quit smoking!",
                        description: "Try to quit smoking for today, everyday is a new day for success!"
                    ),
                    
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
                        title: "Quit smoking!",
                        description: "You've mad this mourning. Good job!"
                    )
                ]
            ),
            Habit(
                id: UUID(),
                name: "🏋🏽‍♀️ Go to the gym",
                weekGoal: 7,
                description: "This a description",
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
                name: "🧉 Drink Yerba Maté",
                weekGoal: 6,
                description: "Antioxidants, lots of health benifits",
                color: .orange,
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
                description: "It's important tot drink lots of water every day. Try to drink a gallon of water and with some salt within it. Otherwise you can die",
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
