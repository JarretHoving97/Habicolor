//
//  LogClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 26/11/2023.
//

import Foundation

struct LogClient {
    
    var all: (_ habit: UUID) -> PersistenceListResult<HabitLog>
    
    var find: (_ habit: UUID, _ date: Date) -> PersistenceResult<HabitLog>
    
    var findInBetween: (_ habit: UUID, _ start: Date, _ end: Date) -> PersistenceListResult<HabitLog>
    
    var logHabit: (_ habit: UUID, _ log: HabitLog) -> PersistenceResult<HabitLog>
    
    var undoLog: (_ id: UUID) -> PersistenceResult<String>
    
}

extension LogClient {
    
    static var live: LogClient = .init(
        all: { id in
            LogProvider.current.all(id: id)
        },
        
        find: { id, date in
            LogProvider.current.get(for: id, date: date)
        }, 
        
        findInBetween: { habit, startDate, endDate in
            LogProvider.current.find(habit: habit, startDate: startDate, endDate: endDate)
        },
        
        logHabit: { habit, log in
            LogProvider.current.add(habit: habit, log: log)
        },
        
        undoLog: { id in
            LogProvider.current.delete(log: id)
        }
    )
}
