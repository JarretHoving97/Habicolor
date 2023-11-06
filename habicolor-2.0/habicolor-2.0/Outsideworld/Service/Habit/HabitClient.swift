//
//  HabitClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/10/2023.
//

import Foundation

struct HabitClient {

    /// fetch app habits.
    var all: () -> PersistenceListResult<Habit>
    
    /// add a habit.
    var add: (_ habit: Habit) -> PersistenceResult<Habit>
    
    /// delete a habit.
    var delete: (_ habit: Habit) -> PersistenceResult<String>
    
    /// update the habit and returns it.
    var updateHabit: (_ habit: Habit, _ id: UUID) -> PersistenceResult<Habit>
}


extension HabitClient {
    
    static let live = HabitClient(
        all: {
            HabitProvider.current.all()
        },
        add: { habit in
            
            HabitProvider.current.add(from: habit)
        },
        delete: { habit in
            HabitProvider.current.delete(habit: habit)
        },
        updateHabit: { habit, id in
            HabitProvider.current.update(habit: habit, id: id)
        }
    )
}
