//
//  HabitProvider.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/10/2023.
//

import Foundation
import CoreData

typealias PersistenceResult<T: Equatable> = (data: T?, error: Error?)
typealias PersistenceListResult<T: Equatable> = (data: [T]?, error: Error?)

class HabitProvider {
    static var current = HabitProvider()
    private let context = CoreDataController.shared.context
}

// MARK: Controller
extension HabitProvider {
    
    func all() -> PersistenceListResult<Habit> {
        return getAllHabits()
    }
    
    func add(from habit: Habit) -> PersistenceResult<Habit> {
        return addHabit(habit)
    }
    
    func delete(habit: Habit) -> PersistenceResult<String> {
        return delete(habit)
    }
    
    func update(habit: Habit, id: UUID) -> PersistenceResult<Habit> {
        return update(habit, for: id)
    }
}

// MARK: Functions
extension HabitProvider {
    
    // create
    private func addHabit(_ habit: Habit) -> PersistenceResult<Habit> {
        
        let nsHabit = NSHabit.newInstance(of: habit, context: context)
        
        do {
            try CoreDataController.shared.saveContext()
            return PersistenceResult(Habit(nsHabit: nsHabit), nil)
        } catch {
            Log.error("Error saving habit: \(String(describing: error.localizedDescription))")
            return PersistenceResult(nil, error)
        }
    }
    
    // read
    private func getAllHabits() -> PersistenceListResult<Habit> {
        
        let fetchRequest: NSFetchRequest<NSHabit> = NSHabit.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = try context.fetch(fetchRequest)
            
            return PersistenceListResult(data.map({Habit(nsHabit: $0)}), nil)
            
        } catch {
            Log.error("Error fetching habits: \(String(describing: error.localizedDescription))")
            return PersistenceListResult(nil, error)
        }
    }
    
    
    // update
    private func update(_ habit: Habit, for id: UUID) -> PersistenceResult<Habit> {

        let fetchRequest: NSFetchRequest<NSHabit> = NSHabit.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                let habitUpdated = result.update(with: habit)
                try context.save()
                return PersistenceResult(Habit(nsHabit: habitUpdated), nil)
            }
    
            throw PersistenceError.updateError
        } catch {
            
            return (nil, error)
        }
    }
    


    // delete
    private func delete(_ habit: Habit) -> PersistenceResult<String> {
        
        let fetchRequest: NSFetchRequest<NSHabit> = NSHabit.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
                return PersistenceResult("SUCCESS", nil)
            }
            
            throw PersistenceError.deletionError
            
        } catch {
            Log.error("Error fetching recipe.. \(String(describing: error))")
            
            return PersistenceResult(nil, error)
        }
    }
    
}
