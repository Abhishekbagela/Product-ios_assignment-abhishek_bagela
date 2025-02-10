//
//  ScrollToTopButton.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 11/02/25.
//

import SwiftUI

struct ScrollToTopButton: View {
    @Binding var isAtBottom: Bool
    var scrollProxy: ScrollViewProxy
    
    var body: some View {
        if isAtBottom {
            Button(action: {
                withAnimation {
                    scrollProxy.scrollTo("top", anchor: .top)
                }
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding()
            .position(x: UIScreen.main.bounds.width - 60, y: UIScreen.main.bounds.height - 120)
        }
    }
}
