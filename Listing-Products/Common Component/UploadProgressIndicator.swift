//
//  UploadProgressIndicator.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 01/02/25.
//

import SwiftUI

struct UploadProgressIndicator: View {
    @Binding var progress: Double // 0.0 to 1.0
    
    var body: some View {
        VStack {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 200)
                .padding(.top, 10)
            
            Text("Uploading: \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    UploadProgressIndicator(progress: .constant(5.0))
}
