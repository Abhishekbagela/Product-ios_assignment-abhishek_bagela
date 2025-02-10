//
//  Product.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation

class Product: Codable {
    var id: String? = UUID().uuidString
    var image: String?
    var price: Double?
    var name: String?
    var type: String?
    var tax: Double?
    var liked: Bool?

    enum CodingKeys: String, CodingKey {
        case image = "image"
        case price = "price"
        case name = "product_name"
        case type = "product_type"
        case tax = "tax"
    }
}
