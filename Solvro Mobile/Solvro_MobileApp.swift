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
            TabView {
                Text("hello, world!")
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                DrinksViewControllerRepresentable()
                    .tabItem {
                        Label("", systemImage: "wineglass")
                    }
                ContentView()
                    .tabItem {
                        Label("", systemImage: "person")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
