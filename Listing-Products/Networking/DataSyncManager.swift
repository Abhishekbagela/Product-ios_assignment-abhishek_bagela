//
//  DataSyncManager.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation
import UIKit

class DataSyncManager {
    
    static let shared = DataSyncManager()
    
    private init() {}

    func syncDataToServer(_ completion: @escaping (Bool)->Void) {
        let unsyncedProducts = ProductRepository.shared.fetchUnsyncedProducts()
        
        guard !unsyncedProducts.isEmpty else {
            debugPrint("No unsynced data found.")
            return
        }
        
        for localProduct in unsyncedProducts {
            
            let newProduct = Product()
            newProduct.price = localProduct.price
            newProduct.name = localProduct.name
            newProduct.type = localProduct.type
            newProduct.tax = localProduct.tax
            var decodedImages: [Data] = []
            
            if let imageData = localProduct.images {
                do {
                    decodedImages = try JSONDecoder().decode([Data].self, from: imageData)
                    debugPrint("Successfully decoded \(decodedImages.count) for product:")
                } catch {
                    debugPrint("Failed to decode images: \(error.localizedDescription)")
                }
            }
            
            APIManager.shared.sendFormData(to: EndPoints.addProductURL(), data: newProduct, images: decodedImages) { (result: Result<Product, APIError>) in
                
                switch result {
                case .success(let product):
                    debugPrint("Synced Product with server ID: \(product.id ?? "").")
                    
                    ProductRepository.shared.markProductAsSynced(localProduct.id, serverId: product.id)
                    completion(true)
                case .failure(_):
                    completion(false)
                    debugPrint("")
                }
            }
        
        }
    }
}

