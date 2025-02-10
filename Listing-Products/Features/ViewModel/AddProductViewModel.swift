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
                DispatchQueue.main.async {
                    self.showMessage(type: .success, message: "Product Added Successfully")
                }                
            }
        }
    }
    
    //MARK: Validation methods
    
    func validateProductName() {
        if productName.isEmpty {
            errorMessages["productName"] = "Product name cannot be empty"
        } else {
            errorMessages["productName"] = nil
        }
    }
    
    func validatePrice() {
        if price.isEmpty || Double(price) == nil {
            errorMessages["price"] = "Please enter a valid price"
        } else {
            errorMessages["price"] = nil
        }
    }
    
    func validateTax() {
        if tax.isEmpty || Double(tax) == nil {
            errorMessages["tax"] = "Please enter a valid tax percentage"
        } else {
            errorMessages["tax"] = nil
        }
    }
    
    func isSubmitDisabled() -> Bool {
        // Disable if ANY error message exists (non-empty)
        return errorMessages.values.contains(where: { !$0.isEmpty }) || isAnyFieldEmpty()
    }
    
    /// Checks if any required fields are empty
    private func isAnyFieldEmpty() -> Bool {
        return productName.isEmpty || price.isEmpty || tax.isEmpty
    }
    
}
