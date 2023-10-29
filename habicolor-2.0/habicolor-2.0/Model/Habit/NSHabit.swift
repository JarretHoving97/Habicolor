//
//  NSHabit.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/10/2023.
//

import Foundation
import CoreData

extension NSHabit {
    
    /// creates a new instance
    static func newInstance(of habit: Habit, context: NSManagedObjectContext) -> NSHabit {
        
        let nsHabit = NSHabit(context: context)
        
        nsHabit.id = habit.id
        nsHabit.name = habit.name
        nsHabit.userDescription = habit.description
        nsHabit.weekGoal = Int16(habit.weekGoal)
        nsHabit.color = habit.color.hexStringFromColor()
        nsHabit.createdAt = Date()
        nsHabit.archived = false
        
        return nsHabit
        
    }
    
    /// update and returns itself
    func update(with habit: Habit) -> Self {
        
        self.name = habit.name
        self.userDescription = habit.description
        self.weekGoal = Int16(habit.weekGoal)
        self.color = habit.color.hexStringFromColor()
        self.createdAt = Date()
        self.archived = false
        
        return self
    }
}
