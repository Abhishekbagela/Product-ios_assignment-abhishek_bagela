//
//  ProductListViewModel.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation

class ProductListViewModel: BaseViewModel {
    
    @Published var searchText: String = ""
    @Published var products: [Product]? = nil
    
    //MARK: Get
    func getProducts() {
        
        let url = EndPoints.getProductURL()

        startLoading()
        
        APIManager.shared.fetchData(from: url) { (result: Result<[Product], APIError>) in
            DispatchQueue.main.async {
                
                self.stopLoading()
                
                switch result {
                case .success(let products):
                    self.products = products
                case .failure(_):
                    self.showMessage(type: .error, message: "Something wend wrong")
                }
            }
        }
        
    }
    
    //MARK: Filter method
    
    func filterProducts(_ products: [Product]?, searchText: String) -> [Product]? {
        guard !searchText.isEmpty else { return products }
        
        return products?.filter { product in
            (product.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
            (product.type?.lowercased().contains(searchText.lowercased()) ?? false) ||
            (String(format: "%.2f", product.price ?? 0.0).contains(searchText))
        }
    }

}

