//
//  NSHabitLog.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 26/11/2023.
//

import Foundation
import CoreData

extension NSHabitLog {
    
    static func create(context: NSManagedObjectContext, log: HabitLog) -> NSHabitLog {
        
        let nsLog = NSHabitLog(context: context)
        nsLog.id = log.id
        nsLog.date = log.logDate
        nsLog.score =  Int16(UInt16(log.emoji.rawValue)) 
        
        return nsLog
    }
}
