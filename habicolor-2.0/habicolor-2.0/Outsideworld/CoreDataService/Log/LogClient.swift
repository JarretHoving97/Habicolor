//
//  LogClient.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 26/11/2023.
//

import Foundation

struct LogClient {
    
    var all: (_ habit: UUID) -> PersistenceListResult<HabitLog>
    
    var logHabit: (_ log: HabitLog) -> PersistenceResult<HabitLog>
    
    var undoLog: (_ id: UUID) -> PersistenceResult<String>
    
}

extension LogClient {
    
    static var live: LogClient = .init(
        all: { id in
            LogProvider.current.all(id: id)
        },
        
        logHabit: { log in
            LogProvider.current.add(log: log)
        },
        
        undoLog: { id in
            LogProvider.current.delete(log: id)
        }
    )
}
