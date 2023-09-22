//
//  DummyTaskApp.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import SwiftUI

@main
struct DummyTaskApp: App {
    
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
