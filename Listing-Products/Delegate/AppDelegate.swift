//
//  AppDelegate.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 31/01/25.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("Application Directory Path: \(NSHomeDirectory())")
        
        return true
    }
}
