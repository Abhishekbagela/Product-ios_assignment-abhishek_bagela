//
//  ProductRepository.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import CoreData
import UIKit

class ProductRepository {
    
    static let shared = ProductRepository()
    private let context = CoreDataManager.shared.context
    
    
    //MARK: ----------- Products -----------
    
    // MARK: - Save Product (Offline First)
    func saveProduct(_ product: Product, _ images: [UIImage]?,  completion: @escaping (Bool)->Void) {
        let entity = ProductEntity(context: context)
        entity.id = UUID()
        entity.serverId = "" // Track sync status
        entity.name = product.name ?? ""
        entity.type = product.type ?? ""
        entity.price = product.price ?? 0.0
        entity.tax = product.tax ?? 0.0
        
        if let images = images {
            // Convert images to Data
            let imageDataArray = images.compactMap { $0.pngData() }
            
            do {
                let encodedData = try JSONEncoder().encode(imageDataArray) // Encode [Data] into Data
                entity.images = encodedData
            } catch {
                print(" Failed to encode images: \(error.localizedDescription)")
            }
        }
        
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
        if CoreDataManager.shared.entityExists("ProductEntity") {
            let fetchRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
            
            // Filter products that do not have a valid server ID (unsynced)
            fetchRequest.predicate = NSPredicate(format: "serverId == nil OR serverId == ''")
            
            do {
                return try context.fetch(fetchRequest)
            } catch {
                print("Error fetching unsynced products: \(error.localizedDescription)")
                return []
            }
        } else {
            print("ProductEntity does not exist yet.")
            return []
        }
    }
    
    // Mark product as synced
    func markProductAsSynced(_ localId: UUID?, serverId: String?) {
        guard let localId, let serverId else { return }
        
        let fetchRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", localId as CVarArg)
        
        do {
            if let product = try context.fetch(fetchRequest).first {
                product.serverId = serverId
                
                CoreDataManager.shared.saveContext()
                print("Updated local product with server ID: \(serverId)")
            }
        } catch {
            print("Error updating product: \(error)")
        }
    }
    
    
    
    //MARK: ----------- LikedProducts -----------
    
    /// Fetch liked products
    func fetchLikedProducts() -> [ProductLikeEntity] {
        
        let fetchRequest = NSFetchRequest<ProductLikeEntity>(entityName: "ProductLikeEntity")

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching unsynced products: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveLikedProduct(_ product: Product?) {
        guard let product else { return }
        let id = product.getId()

        let entity = ProductLikeEntity(context: context)
        entity.id = id
        
        CoreDataManager.shared.saveContext()
    }
 
    func deleteLikedProduct(_ product: Product?) {
        guard let product else { return }
        let id = product.getId()
        
        let fetchRequest = NSFetchRequest<ProductLikeEntity>(entityName: "ProductLikeEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let product = try context.fetch(fetchRequest).first {
                context.delete(product)
                CoreDataManager.shared.saveContext()
                print("Deleted local product with image: \(id)")
            } else {
                print("Product not found with image: \(id)")
            }
        } catch {
            print("Error in deleting local product with image: \(id)")
        }
    }
    
}

