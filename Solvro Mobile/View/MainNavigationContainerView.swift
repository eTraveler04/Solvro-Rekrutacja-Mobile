//
//  MainNavigationContainerView.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 21/03/2025.
//

import SwiftUI

struct MainNavigationContainerView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            TabView {
                FavDrinkCardView()
                    .tabItem {
                        Label("", systemImage: "lanyardcard")
                    }
                
                DrinksViewControllerRepresentable()
                    .tabItem {
                        Label("", systemImage: "wineglass")
                    }
                
                FavoritesListView()
                    .tabItem {
                        Label("", systemImage: "star")
                    }
            }
            .navigationTitle("Solvro Mobile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeSwitcherView(isDarkMode: $isDarkMode)
                        .labelsHidden()
                }
            }
        }
    }
}

struct MainNavigationContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationContainerView()
    }
}
