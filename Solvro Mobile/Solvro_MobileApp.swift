//
//  Solvro_MobileApp.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import SwiftUI

@main
struct Solvro_MobileApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    let persistenceController = PersistenceController.shared
    @ObservedObject var favoritesManager = FavoritesManager.shared
    init() {
        // Configure UITabBar appearance to use your custom asset color.
        let tabBarAppearance = UITabBarAppearance()
        // For example we use the UIColor version of your "Background" asset.
        tabBarAppearance.backgroundColor = UIColor(named: "Background")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Configure UINavigationBar appearance to use your custom asset color.
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "Background")
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Use your custom asset color as the entire background.
                Color("Background")
                    .ignoresSafeArea()
                
                TabView {
                    FavDrinkCardView()
                        .tabItem {
                            Label("", systemImage: "house")
                        }
                    
                    DrinksViewControllerRepresentable()
                        .tabItem {
                            Label("", systemImage: "wineglass")
                        }
                    
                    FavoritesListView()
                        .tabItem {
                            Label("", systemImage: "star")
                        }
                    
                    ThemeSwitcherView(isDarkMode: $isDarkMode)
                        .tabItem {
                            Label("", systemImage: "gear")
                        }
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
    }
}
