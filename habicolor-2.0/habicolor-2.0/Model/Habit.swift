//
//  Habit.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 06/10/2023.
//

import SwiftUI
import Foundation


struct Habit: Hashable, Equatable, Identifiable {
    let id = UUID()
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
                name: "Quit smoking..",
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
                name: "Go to the gym",
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
        ]
    }
}
