//
//  DummyTaskApp.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import SwiftUI
import IQKeyboardManagerSwift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.shared.enable = true
        return true
    }
}

@main
struct DummyTaskApp: App {
    
    @StateObject var appState = AppState()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
