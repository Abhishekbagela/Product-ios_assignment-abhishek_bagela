//
//  CoreDataManager.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ProductModel")
        
        //        NOTE: ☠️ Use it wisely(Only in Dev Mode)
        //        self.deleteStore()
        
        //TODO: Need to configure light and heavy weight migration
        
        // Enable automatic lightweight migration
        let description = self.persistentContainer.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data: \(error)")
            }
        }
    }
    
    private func deleteStore() {
        do {
            try FileManager.default.removeItem(at: self.persistentContainer.persistentStoreDescriptions.first!.url!)
            try self.persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete store: \(error)")
        }
    }
    
    func entityExists(_ entityName: String) -> Bool {
        let entities = persistentContainer.managedObjectModel.entities
        return entities.contains { $0.name == entityName }
    }
}
