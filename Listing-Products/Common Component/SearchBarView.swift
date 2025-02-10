//
//  SearchBarView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        isEditing = true
                    }
                }
                .onChange(of: text) { newValue in
                    withAnimation {
                        isEditing = !newValue.isEmpty  // Set isEditing to true when text is not empty
                    }
                }
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        isEditing = false
                        text = ""
                        UIApplication.shared.dismissKeyboard()
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

#Preview {
    SearchBarView(text: .constant("Test"))
}
