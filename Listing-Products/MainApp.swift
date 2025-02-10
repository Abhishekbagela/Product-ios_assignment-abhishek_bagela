//
//  MainApp.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var navigationRouter = NavigationRouter()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationRouter.path) {
                RootView {
                    SplashView()
                        .onAppear {
                            //MARK: Sync data with server and update local
                            if (networkMonitor.isConnected) {
                                DataSyncManager.shared.syncDataToServer({_ in})
                            }
                        }
                }
                .environmentObject(networkMonitor)
                .environmentObject(navigationRouter)
            }
        }
    }
    
    /*
    //MARK: To update navigation bat properties
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#DF6D2D") // Set navigation bar color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Change title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Change large title color
                        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.white
    }*/
}
