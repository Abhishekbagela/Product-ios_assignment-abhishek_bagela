//
//  Mapper.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation

final class Mapper {
    static func toEntity(_ product: Product) -> ProductEntity {
        let entity = ProductEntity()
        entity.name = product.name ?? ""
        entity.type = product.type ?? ""
        entity.image = product.image ?? ""
        entity.price = product.price ?? 0.0
        entity.tax = product.tax ?? 0.0        
        
        return entity
    }
}
