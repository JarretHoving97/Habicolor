//
//  Habit.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import Foundation


struct Habit: Hashable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let color: Color
    let weekHistory: [Int]
    let notifications: [Notification]
}


// MARK: Dummy Collection
extension Habit {
    
    static var example: Habit {
        return Habit(
            id: UUID(),
            name: "Go to the gym",
            description: "Get that body you want!",
            color: .pink,
            weekHistory: [1, 4, 5, 5],
            notifications: [
                Notification(
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
                description: "Smoking causes alot of health problems including different types of cancer.",
                color: .red,
                weekHistory: [5, 3, 2, 4, 2, 1],
                notifications: [
                    Notification(
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
                    
                    Notification(
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
                description: "This a description",
                color: .green,
                weekHistory: [5, 3, 2, 4, 2, 1],
                notifications: [
                    Notification(
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
                description: "Antioxidants, lots of health benifits",
                color: .orange,
                weekHistory: [5, 3, 2, 4, 2, 1],
                notifications: [
                    Notification(
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
                description: "It's important tot drink lots of water every day. Try to drink a gallon of water and with some salt within it. ",
                color: .green,
                weekHistory: [5, 3, 2, 4, 2, 1],
                notifications: [
                    Notification(
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
