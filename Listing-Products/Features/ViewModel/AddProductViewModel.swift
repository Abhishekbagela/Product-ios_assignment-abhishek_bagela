//
//  AddProductViewModel.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation
import UIKit

class AddProductViewModel: BaseViewModel {
    
    @Published var productName: String = ""
    @Published var productType: String = "Electronics"
    @Published var price: String = ""
    @Published var tax: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var isImagePickerPresented = false
    @Published var errorMessages: [String: String] = [:]
    
    let productTypes = ["Electronics", "Clothing", "Accessories", "Books", "Home Appliance"]
    
    //MARK: Add
    func addProduct() {
        
        startLoading()
        
        let product: Product = Product()
        product.name = self.productName
        product.type = self.productType
        product.price = Double(self.price)
        product.tax = Double(self.tax)
        
        var images: [UIImage] = []
        
        if let image = selectedImage {
            images.append(image)
        }
        
        //Save data locally
        ProductRepository.shared.saveProduct(product, images) { success in
            self.stopLoading()
            
            if (success) {
                self.showMessage(type: .success, message: "Product Added Successfully")
            } else {
                self.showMessage(type: .error, message: "Something went wrong. Please try again later.")
            }
        }
    }
    
    //MARK: Validation methods
    
    func showProductNameInvalidMsg() {
        if ValidationUtility.validateName(self.productName) {
            errorMessages["productName"] = "Product name cannot be empty"
        } else {
            errorMessages["productName"] = nil
        }
    }
    
    func showPriceInvalidMsg() {
        if ValidationUtility.validatePrice(self.price) {
            errorMessages["price"] = "Please enter a valid price"
        } else {
            errorMessages["price"] = nil
        }
    }
    
    func showTaxInvalidMsg() {
        if ValidationUtility.validateTax(self.tax) {
            errorMessages["tax"] = "Please enter a valid tax percentage"
        } else {
            errorMessages["tax"] = nil
        }
    }
    
    func isSubmitDisabled() -> Bool {
        // Disable if ANY error message exists (non-empty)
        return errorMessages.values.contains(where: { !$0.isEmpty }) || ValidationUtility.isAnyTextFieldEmpty(productName, price, tax)
    }
    
}

struct ValidationUtility: ValidationUtilityProtocol {
    static func validatePrice(_ price: String) -> Bool {
        if (price.isEmpty || Double(price) == nil || (Double(price) ?? 0) <= 0) {
            return false
        } else {
            return true
        }
    }
    
    static func validateName(_ name: String) -> Bool {
        if (name.isEmpty || name.count > 2) {
            return false
        } else {
            return true
        }
    }
    
    static func validateTax(_ tax: String) -> Bool {
        if (tax.isEmpty || Double(tax) == nil) {
            return false
        } else {
            return true
        }
    }
    
    /// Checks if any required fields are empty
    static func isAnyTextFieldEmpty(_ textFields: String...) -> Bool {
        if textFields.allSatisfy({ $0.isEmpty == true }) {
            return true
        } else {
            return false
        }
    }
}

protocol ValidationUtilityProtocol {
    
    static func validatePrice(_ price: String) -> Bool
    static func validateName(_ name: String) -> Bool
    static func validateTax(_ tax: String) -> Bool
    static func isAnyTextFieldEmpty(_ textFields: String...) -> Bool
}
