//
//  SignAppApp.swift
//  SignApp
//
//  Created by Hugo Rodrigues on 04/03/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SignAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isAuthenticated {
                    LoginView()
                        .environmentObject(AuthViewModel())
                        
                } else {
                    ContentView()
                        .environmentObject(authViewModel)
                        
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
