//
//  k_MMSEApp.swift
//  k-MMSE
//
//  Created by mac on 3/18/25.
//

import SwiftUI
import SwiftData

@main
struct k_MMSEApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            GameResult.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
