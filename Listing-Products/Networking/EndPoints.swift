//
//  EndPoints.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation

struct EndPoints {
    //BASE
    static var baseURL = "https://app.getswipe.in/api/public"
    
    //EndPoint
    static let getProduct = "/get"
    static let addProduct = "/add"
    
    static func getProductURL() -> URL? {
        return URL(string: baseURL + getProduct)
    }
    
    static func addProductURL() -> URL? {
        return URL(string: baseURL + addProduct)
    }
    
}
