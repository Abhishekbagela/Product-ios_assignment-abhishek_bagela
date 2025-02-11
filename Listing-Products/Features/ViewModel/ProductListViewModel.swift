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
    @Published var likedProducts: [Product] = []
    
    @Published var isAtBottom = false
    
    //MARK: Get
    func getProducts() {
        
        let url = EndPoints.getProductURL()
        
        startLoading()
        
        APIManager.shared.fetchData(from: url) { (result: Result<[Product], APIError>) in
            DispatchQueue.main.async {
                
                self.stopLoading()
                
                switch result {
                case .success(let products):
                    self.showLikedProductOnTop(products)
                case .failure(_):
                    self.showMessage(type: .error, message: "Something wend wrong")
                }
            }
        }
    }
        
    func resetProductsList() {
        self.likedProducts = []
        self.products = []
    }
    
    func showLikedProductOnTop(_ products: [Product]) {
        resetProductsList()
        
        var nonLiked = [Product]()
        
        let likedProducts = ProductRepository.shared.fetchLikedProducts()
        
        if (likedProducts.isEmpty) {
            self.products = products
        } else {
            products.forEach { product in
                let id = product.getId()
                
                if likedProducts.contains(where: { $0.id == id }) {
                    let prd = product
                    prd.liked = true
                    self.likedProducts.append(prd)
                    
                } else {
                    nonLiked.append(product)
                }
            }
            
            print("xxxx liked \(self.likedProducts.count)")
            print("xxxx nonLiked \(nonLiked.count)")
            
            self.products = self.likedProducts + nonLiked
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
