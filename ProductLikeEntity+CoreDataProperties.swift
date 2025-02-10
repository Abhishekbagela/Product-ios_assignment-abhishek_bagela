//
//  ProductLikeEntity+CoreDataProperties.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 10/02/25.
//
//

import Foundation
import CoreData


extension ProductLikeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductLikeEntity> {
        return NSFetchRequest<ProductLikeEntity>(entityName: "ProductLikeEntity")
    }

    @NSManaged public var id: String?

}

extension ProductLikeEntity : Identifiable {

}
