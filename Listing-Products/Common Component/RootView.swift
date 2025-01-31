//
//  RootView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import SwiftUI

struct RootView<Content: View>: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Dismiss keyboard when tapping outside
            content
                .background(Color.clear)
                .onTapGesture {
                    hideKeyboard()
                }
            
            // Show network status banner
            if !(networkMonitor.isConnected) {
                NetworkStatusView()
            }
        }
        .environmentObject(networkMonitor)
        .environmentObject(navigationRouter)
    }
}

#Preview {
    RootView {
        EmptyView()
    }
}
