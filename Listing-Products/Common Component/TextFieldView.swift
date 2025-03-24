//
//  TextFieldView.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 24/03/25.
//

import SwiftUI

struct TextFieldView: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }
}

struct TextFieldWithFieldLabelView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var onTextChange: (String) -> Void = { _ in }
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.headline)
            TextField(placeholder, text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        }
        .onChange(of: text, perform: onTextChange)
    }
}

