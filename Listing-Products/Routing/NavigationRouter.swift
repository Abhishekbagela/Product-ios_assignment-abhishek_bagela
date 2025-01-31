//
//  NavigationRouter.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case addProduct
}

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    /// Push a new view
    func push(_ route: Route) {
        path.append(route)
    }
    
    /// Pop to the previous view
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Go back to the root
    func popToRoot() {
        path = NavigationPath()
    }
    
    /// Set a new root view
    func setRoot(_ route: Route) {
        path = NavigationPath()
        path.append(route)
    }
}
