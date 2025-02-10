//
//  ProductEntity+CoreDataProperties.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 07/02/25.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var images: Data?
    @NSManaged public var price: Double
    @NSManaged public var tax: Double
    @NSManaged public var type: String?
    @NSManaged public var serverId: String?

}

extension ProductEntity : Identifiable {

}
