//
//  ProductRepository.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import CoreData

class ProductRepository {
    
    static let shared = ProductRepository()
    private let context = CoreDataManager.shared.context
    
    // MARK: - Save Product (Offline First)
    func saveProduct(_ product: Product, isSynced: Bool = false, completion: @escaping (Bool)->Void) {
        let entity = ProductEntity(context: context)
        entity.id = UUID()
        entity.serverId = nil // Track sync status
        entity.name = product.name ?? ""
        entity.type = product.type ?? ""
        entity.price = product.price ?? 0.0
        entity.tax = product.tax ?? 0.0
        entity.image = product.image ?? ""
        
        CoreDataManager.shared.saveContext()
        
        // If online, try syncing immediately
        if NetworkMonitor.shared.isConnected {
            DataSyncManager.shared.syncDataToServer() { success in
                completion(success)
            }
        } else {
            completion(true)
        }
    }
    
    /// Fetch products that have not been synced with the server
    func fetchUnsyncedProducts() -> [ProductEntity] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        // Filter products that do not have a valid server ID (unsynced)
        fetchRequest.predicate = NSPredicate(format: "serverId == nil OR serverId == ''")
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching unsynced products: \(error.localizedDescription)")
            return []
        }
    }
    
    // Mark product as synced
    func markProductAsSynced(_ localId: UUID?, serverId: String?) {
        guard let localId, let serverId else { return }
        
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", localId as CVarArg)
        
        do {
            if let product = try context.fetch(fetchRequest).first {
                product.serverId = serverId
                
                try context.save()
                print("Updated local product with server ID: \(serverId)")
            }
        } catch {
            print("Error updating product: \(error)")
        }
    }
}

