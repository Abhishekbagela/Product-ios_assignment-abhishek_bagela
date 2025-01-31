//
//  Extension+View.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 30/01/25.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
