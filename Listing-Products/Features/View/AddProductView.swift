//
//  AddProductView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI
import PhotosUI
import Combine

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Product Image Section
                        Button(action: { viewModel.isImagePickerPresented.toggle() }) {
                            ZStack {
                                if let image = viewModel.selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                                } else {
                                    VStack {
                                        Image(systemName: "photo.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray)
                                        Text("Tap to add image")
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                    }
                                    .frame(width: 150, height: 150)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                
                            }
                        }
                        .padding(.top, 20)
                        .sheet(isPresented: $viewModel.isImagePickerPresented) {
                            ImagePicker(image: $viewModel.selectedImage)
                        }
                        
                        // Text Fields and Validation
                        VStack(alignment: .leading, spacing: 10) {
                            // Product Name
                            TextFieldWithFieldLabelView(label: "Product Name",
                                                        placeholder: "Enter product name",
                                                        text: $viewModel.productName) { _ in
                                viewModel.showProductNameInvalidMsg()
                            }
                            if let productNameError = viewModel.errorMessages["productName"] {
                                Text(productNameError)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            
                            // Product Type
                            Text("Product Type")
                                .font(.headline)
                            Picker("Select Type", selection: $viewModel.productType) {
                                ForEach(viewModel.productTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            
                            // Price
                            TextFieldWithFieldLabelView(label: "Price ($)",
                                                        placeholder: "Enter price",
                                                        text: $viewModel.price) { _ in
                                viewModel.showPriceInvalidMsg()
                            }
                            if let priceError = viewModel.errorMessages["price"] {
                                Text(priceError)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            
                            // Tax
                            TextFieldWithFieldLabelView(label: "Tax (%)",
                                                        placeholder: "Enter tax",
                                                        text: $viewModel.tax) { _ in
                                viewModel.showTaxInvalidMsg()
                            }
                            if let taxError = viewModel.errorMessages["tax"] {
                                Text(taxError)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Submit Button
                        Button(action: viewModel.addProduct) {
                            Text("Add Product")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        .disabled(viewModel.isSubmitDisabled() || viewModel.loading)
                    }
                    .padding()
                }
                
                if (viewModel.loading) {
                    LoadingView()
                }
            }
        }
        .navigationTitle("Add Product")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.msgTitle), message: Text(viewModel.message))
        }
    }
    
}

#Preview {
    AddProductView()
}
