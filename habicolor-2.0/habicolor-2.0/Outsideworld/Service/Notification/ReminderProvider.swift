//
//  NotificationProvider.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 30/10/2023.
//

import Foundation
import CoreData


class ReminderProvider {
    static var current = ReminderProvider()
    private let context = CoreDataController.shared.context
}


// MARK: Controller
extension ReminderProvider {
    
    func all(_ habit: UUID) -> PersistenceListResult<Reminder> {
        return all(for: habit)
    }
    
    func add(_ habit: UUID, notification: Reminder) -> PersistenceResult<Reminder> {
        return addNotification(habit, notification)
    }
    
    func deleteAll(for habit: UUID) {
        deleteAll(habit)
    }
}

// MARK: Funtions
extension ReminderProvider {
    
    // read
    private func all(for habit: UUID) -> PersistenceListResult<Reminder> {
        
        do {
            guard let habit = try findHabit(for: habit).data, let reminders = habit.reminders?.allObjects as? [NSReminder] else { throw PersistenceError.loadError }
            
            let notifications = reminders.map({Reminder($0)})
            
            return (notifications, nil)
            
        } catch {
            return (nil, error)
        }
        
    }
    
    // create
    private func addNotification(_ habit: UUID, _ notification: Reminder)  -> PersistenceResult<Reminder> {
        
        let nsNotification = NSReminder.newInstance(of: notification, context: context)
    
        do {
            guard let nshabit = try findHabit(for: habit).data else { throw PersistenceError.loadError }
            
            nshabit.addToReminders(nsNotification)
            
            try CoreDataController.shared.saveContext()
            
            return PersistenceResult(Reminder(nsNotification), nil)
        } catch {
            
            return (nil, error)
        }
    }
    
    // delete
    private func deleteAll(_ habit: UUID) {
        
        do {
            guard let nshabit = try findHabit(for: habit).data else { throw PersistenceError.loadError }
            
            // Get the reminders associated with the habit
            if let reminders = nshabit.reminders {
                
                for reminder in reminders {
                    context.delete(reminder as! NSManagedObject)
                }
                
                // Save the context to persist the changes
                do {
                    try context.save()
                } catch {
                    print("Error clearing reminders for the habit: \(error)")
                }
            }
            
        } catch {
            Log.error(String(describing: error))
            
        }
    }
    
    
    // Find parent
    private func findHabit(for id: UUID) throws -> PersistenceResult<NSHabit>{
        
        let fetchRequest: NSFetchRequest<NSHabit> = NSHabit.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                return PersistenceResult(result, nil)
            }
    
            throw PersistenceError.updateError
        } catch {
            
            throw error
        }
    }
    
    
}
