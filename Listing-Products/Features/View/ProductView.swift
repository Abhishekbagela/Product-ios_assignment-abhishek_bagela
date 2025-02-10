//
//  ProductView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI

struct ProductView: View {
    let product: Product?
    @ObservedObject var viewModel: ProductListViewModel
    @State private var productImage: UIImage? = nil
    @State private var isLiked = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                productImageView
                    .frame(width: 180, height: 180)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 4, y: 6)
                    .padding(.top, 10)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLiked.toggle()
                        updateLikedProducts()
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isLiked ? .red : .white)
                        .padding(12)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product?.name ?? "Unknown Product")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(product?.type ?? "Category")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(String(format: "%.2f", product?.price ?? 0.00))")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text("Tax: $\(String(format: "%.2f", product?.tax ?? 0.00))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 3, y: 5)
        )
        .padding(.horizontal)
        .animation(.spring(), value: isLiked)
        .onAppear {
            self.isLiked = product?.liked ?? false
            loadImage()
        }
    }
    
    private var productImageView: some View {
        Group {
            if let image = productImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: 180, height: 180)
            }
        }
    }
    
    private func loadImage() {
        guard let imageUrl = product?.image else { return }
        
        APIManager.shared.downloadImage(from: imageUrl) { (result: Result<UIImage, APIError>) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.productImage = image
                }
            case .failure(_): print("Failed to load image")
            }
        }
    }
    
    private func updateLikedProducts() {
        guard let product = product else { return }
        
        if isLiked {
            ProductRepository.shared.saveLikedProduct(product.image)
        } else {
            ProductRepository.shared.deleteLikedProduct(product.image)
        }
        
        //Refresh list
        viewModel.getProducts()
    }
}

#Preview {
    ProductView(product: nil, viewModel: ProductListViewModel())
}
