//
//  TOHApp.swift
//  TOH
//
//  Created by Alia on 2025/1/15.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.min)  // 關閉 Firebase log

    Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
      
    return true
  }

}

@main
struct TOHApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(ModelData())
        }
    }
}
