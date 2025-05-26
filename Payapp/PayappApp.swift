//
//  PayappApp.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct PayApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


      var body: some Scene {
        WindowGroup {
            RootView()
        }
      }
}
