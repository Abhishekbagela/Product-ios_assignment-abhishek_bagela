//
//  NetworkStatusView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import SwiftUI

struct NetworkStatusView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "wifi.exclamationmark") // Warning icon
                    .foregroundColor(.white)
                    .imageScale(.large)
                
                Text("No Internet Connection")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(5)
            .frame(maxWidth: .infinity)
            .background(Color.red) // Red background for offline warning
            .transition(.move(edge: .top))
            .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    NetworkStatusView()
}
