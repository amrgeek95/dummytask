//
//  DummyTaskApp.swift
//  DummyTask
//
//  Created by Mac on 13/09/2023.
//

import SwiftUI

@main
struct DummyTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
