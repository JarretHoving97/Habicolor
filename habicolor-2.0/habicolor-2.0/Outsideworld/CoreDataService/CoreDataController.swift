//
//  HabitCoreDataController.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 29/10/2023.
//

import Foundation
import CoreData

class CoreDataController  {
    static var shared = CoreDataController()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private let containerName = "Habit"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    public func saveContext() throws {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                let nserror = error as NSError
                
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

