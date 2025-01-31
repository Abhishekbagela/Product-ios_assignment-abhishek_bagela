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
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            
//            NOTE: ☠️ Use it wisely
//            deleteStore()
            
            // Enable automatic lightweight migration
            let description = self.persistentContainer.persistentStoreDescriptions.first
            description?.shouldMigrateStoreAutomatically = true
            description?.shouldInferMappingModelAutomatically = true
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
}
