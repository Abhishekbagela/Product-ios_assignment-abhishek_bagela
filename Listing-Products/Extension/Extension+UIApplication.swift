//
//  Extension+UIApplication.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
