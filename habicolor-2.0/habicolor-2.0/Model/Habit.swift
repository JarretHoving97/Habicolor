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
    let color: Color
    let weekHistory: [Int]
}


// MARK: Dummy Collection
extension Habit {
    
    static var staticContent: [Habit] {
        
        return [
            Habit(name: "Quit smoking 🚬", color: .red, weekHistory: [5, 3, 2, 4, 2, 1]),
            Habit(name: "Go to the gym", color: .green, weekHistory: [5, 3, 2, 4, 2, 1]),
            Habit(name: "Intermittend fast", color: .blue, weekHistory: [5, 3, 2, 4, 2, 1]),
            Habit(name: "Eat healthy", color: .purple, weekHistory: [5, 3, 2, 4, 2, 1]),
            Habit(name: "Breathe exercises", color: .pink, weekHistory: [5, 3, 2, 4, 2, 1])
        
        ]
    }
}
