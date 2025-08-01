//
//  hsappsoccerApp.swift
//  hsappsoccer
//
//  Created by Hamza on 7/31/25.
//

import SwiftUI
import SwiftData

@main
struct hsappsoccerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Player.self,
            Team.self,
            League.self,
            Draft.self
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
                .onAppear {
                    // Populate player data on first launch
                    let context = sharedModelContainer.mainContext
                    PlayerDataService.shared.populatePlayers(context: context)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
