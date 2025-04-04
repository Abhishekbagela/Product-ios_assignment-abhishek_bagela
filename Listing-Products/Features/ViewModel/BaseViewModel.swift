//
//  BaseViewModel.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var msgTitle: String = ""
    @Published var message: String = ""
    
    @Published var showError: Bool = false
    @Published var loading: Bool = false
    
    enum MessageType: String {
        case success = "Success"
        case error = "Error"
    }
    
    func showMessage(type: MessageType, message: String) {
        DispatchQueue.main.async {
            self.msgTitle = type.rawValue
            self.message = message
            self.showError = true
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.loading = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
}
