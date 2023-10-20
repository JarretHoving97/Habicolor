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
}


// MARK: Dummy Collection
extension Habit {
    
    static var staticContent: [Habit] {
        
        return [
            Habit(
                name: "Quit smoking 🚬",
                description: "Smoking causes alot of health problems including different types of cancer.",
                color: .red,
                weekHistory: [5, 3, 2, 4, 2, 1]
            ),
            Habit(
                name: "Go to the gym",
                description: "This a description",
                color: .green,
                weekHistory: [5, 3, 2, 4, 2, 1]
            ),
        ]
    }
}
