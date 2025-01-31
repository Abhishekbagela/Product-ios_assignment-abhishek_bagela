//
//  DataSyncManager.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation

class DataSyncManager {
    
    static let shared = DataSyncManager()
    
    private init() {}

    func syncDataToServer(_ completion: @escaping (Bool)->Void) {
        let unsyncedProducts = ProductRepository.shared.fetchUnsyncedProducts()
        
        guard !unsyncedProducts.isEmpty else {
            print("No unsynced data found.")
            return
        }
        
        for localProduct in unsyncedProducts {
            
            let newProduct = Product()
            newProduct.image = localProduct.image
            newProduct.price = localProduct.price
            newProduct.name = localProduct.name
            newProduct.type = localProduct.type
            newProduct.tax = localProduct.tax
            
            APIManager.shared.sendFormData(to: EndPoints.addProductURL(), data: newProduct) { (result: Result<Product, APIError>) in
                
                switch result {
                case .success(let product):
                    print("Synced Product with server ID: \(product.id ?? "").")
                    
                    ProductRepository.shared.markProductAsSynced(localProduct.id, serverId: product.id)
                    completion(true)
                case .failure(_):
                    completion(false)
                    print("")
                }
            }
        
        }
    }
}

