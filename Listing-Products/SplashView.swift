//
//  SplashView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 01/02/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale = 0.5
    @State private var gradientColors: [Color] = [.blue, .purple]
    
    var body: some View {
        if isActive {
            // Navigate to HomeScreen (Replace with actual main view)
            ProductListView()
        } else {
            ZStack {
                // Animated Gradient Background
                LinearGradient(gradient: Gradient(colors: gradientColors),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    animateGradient()
                }
                
                VStack {
                    // App Logo with Scaling Animation
                    Image(systemName: "cart.fill") // Replace with your logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .animation(.easeInOut(duration: 1.5), value: logoScale)
                    
                    // Loading Indicator
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }
            }
            .onAppear {
                withAnimation {
                    logoScale = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
                }
            }
        }
    }
    
    /// Animate Gradient Background Colors
    private func animateGradient() {
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: true)) {
            gradientColors = [.purple, .blue] // Swap colors for animation effect
        }
    }
}

#Preview {
    SplashView()
}
