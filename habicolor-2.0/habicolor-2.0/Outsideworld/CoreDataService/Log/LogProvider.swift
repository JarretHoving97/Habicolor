//
//  LogHabitProvider.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 26/11/2023.
//

import Foundation
import CoreData

class LogProvider {
    static let current = LogProvider()
    private let context = CoreDataController.shared.context
}

// MARK: Controller
extension LogProvider {
    
    func all(id: UUID) -> PersistenceListResult<HabitLog> {
        return getAllLogs(for: id)
    }
    
    func add(log: HabitLog) -> PersistenceResult<HabitLog> {
        return addLog(log: log)
    }
    
    func delete(log: UUID) -> PersistenceResult<String> {
        return delete(log)
    }
}

// MARK: Functions
extension LogProvider {
    
    // create
    private func addLog(log: HabitLog) -> PersistenceResult<HabitLog> {
        let nsLog = NSHabitLog.create(context: context, log: log)
        
        do {
            try CoreDataController.shared.saveContext()
            return PersistenceResult(HabitLog(nsHabitLog: nsLog), nil)
        } catch {
            Log.error("Error saving log: \(String(describing: error.localizedDescription))")
            return PersistenceResult(nil, error)
        }
    }
    
    // read
    private func getAllLogs(for habit: UUID) -> PersistenceListResult<HabitLog> {
        let fetchRequest: NSFetchRequest<NSHabitLog> = NSHabitLog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = try context.fetch(fetchRequest)
            
            return PersistenceListResult(data.map({HabitLog(nsHabitLog: $0)}), nil)
            
        } catch {
            Log.error("Error fetching logs: \(String(describing:error.localizedDescription))")
            return PersistenceListResult(nil, error)
        }
    }
    
    // delete
    private func delete(_ id: UUID) -> PersistenceResult<String> {
        let fetchRequest: NSFetchRequest<NSHabitLog> = NSHabitLog.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
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
