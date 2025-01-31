//
//  ContentView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        VStack {
            if (viewModel.loading) {
                LoadingView()
            } else {
                SearchBarView(text: $viewModel.searchText)
                
                if (viewModel.products?.isEmpty == false) {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.filterProducts(viewModel.products, searchText: viewModel.searchText) ?? [], id: \.id) { product in
                                ProductListItemView(product: product)
                            }
                        }
                    }
                    .padding(.top, 5)
                } else {
                    Spacer()
                }
            }
            
        }
        .navigationTitle("Products")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Add Product") {
            navigationRouter.push(.addProduct)
        })
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .addProduct:
                AddProductView()
            }
        }
        .onAppear {
            viewModel.getProducts()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.msgTitle), message: Text(viewModel.message))
        }
    }
        
}

#Preview {
    ProductListView()
}
