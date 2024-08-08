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
    
    func get(for id: UUID, date: Date) -> PersistenceResult<HabitLog> {
        getLog(for: id, date: date)
    }
    
    func add(habit: UUID, log: HabitLog) -> PersistenceResult<HabitLog> {
        return addLog(habit: habit, log: log)
    }
    
    func delete(log: UUID) -> PersistenceResult<String> {
        return delete(log)
    }
}

// MARK: Functions
extension LogProvider {
    
    // create
    private func addLog(habit: UUID, log: HabitLog) -> PersistenceResult<HabitLog> {

        // delete log if found
        if let todaysHabit = getLog(for: habit, date: log.logDate).data {
            let _ = delete(todaysHabit.id)
        }
        
        let nsLog = NSHabitLog.create(context: context, habit: habit, log: log)

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
        
        let habitPredicate = NSPredicate(format: "habitId == %@", habit as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        let predicate = habitPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        do {
            let data = try context.fetch(fetchRequest)
            return PersistenceListResult(data.map({HabitLog(nsHabitLog: $0)}), nil)
            
        } catch {
            return PersistenceListResult(nil, error)
        }
    }
    
    private func getLog(for habit: UUID, date: Date) -> PersistenceResult<HabitLog> {
        
        let fetchRequest: NSFetchRequest<NSHabitLog> = NSHabitLog.fetchRequest()
        
        let dateTo = date.endOfDay
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        let datePredicate = NSPredicate(format: "date >= %@", date as NSDate)
        // Set predicate as date being today's date
        let dateToPredicate = NSPredicate(format: "date <= %@", dateTo as NSDate)
        
        let habitPredicate = NSPredicate(format: "habitId == %@", habit as CVarArg)
        
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, dateToPredicate, habitPredicate])
        
        fetchRequest.predicate = predicate
        
        do {
            if let result = try context.fetch(fetchRequest).last {
                
                return PersistenceResult(HabitLog(nsHabitLog: result), nil)
            }
        
            throw PersistenceError.loadError
        } catch {
            return PersistenceResult(nil, error)
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
    
    
    // find in between dayes
    func find(habit: UUID, startDate: Date, endDate: Date) -> PersistenceListResult<HabitLog> {
        var allDays: [Date] = []
        
        var currentDate = startDate

        while currentDate <= endDate {
            allDays.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let logs = allDays.compactMap({getLog(for: habit, date: $0).data})
        
        return PersistenceListResult(logs, nil)
    }
}
