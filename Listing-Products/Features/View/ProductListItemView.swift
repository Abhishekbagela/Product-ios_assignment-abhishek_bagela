//
//  ProductListItemView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI

struct ProductListItemView: View {
    let product: Product?
    
    @State private var productImage: UIImage? = nil
    @State private var isLiked = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                productImageView
                    .frame(width: 160, height: 160)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, Color.gray.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 3, y: 3)
                    .padding(.top, 8)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLiked.toggle()
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(isLiked ? .pink : .gray)
                        .padding(12)
                        .background(BlurView(style: .systemThinMaterial))
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product?.name ?? "Unknown Product")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(product?.type ?? "Category")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(String(format: "%.2f", product?.price ?? 0.00))")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Tax: $\(String(format: "%.2f", product?.tax ?? 0.00))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 2, y: 5)
        )
        .padding(.horizontal)
        .scaleEffect(isLiked ? 1.05 : 1.0)
        .animation(.spring(), value: isLiked)
        .onAppear {
            loadImage()
        }
    }
    
    private var productImageView: some View {
        Group {
            if let image = productImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: 160, height: 160)
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
            case .failure(_): print("")
            }
        }
    }
}

// **BlurView for Glassmorphism effect**
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


#Preview {
    ProductListItemView(product: nil)
}
