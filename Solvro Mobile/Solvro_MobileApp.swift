//
//  Solvro_MobileApp.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import SwiftUI

@main
struct Solvro_MobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
