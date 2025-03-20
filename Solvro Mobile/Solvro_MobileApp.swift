import SwiftUI

@main
struct Solvro_MobileApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    let persistenceController = PersistenceController.shared
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()  // Konfigurujemy wygląd z przezroczystym tłem
        if let bgImage = UIImage(named: "CardBackground") {
            tabBarAppearance.backgroundImage = bgImage
            // Opcjonalnie: ustawienie tła na przezroczyste, aby obraz był widoczny
            tabBarAppearance.backgroundColor = .clear
        }
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        UIView.appearance(whenContainedInInstancesOf: [UIHostingController<AnyView>.self]).backgroundColor = UIColor(named: "Background")
    }


    var body: some Scene {
        WindowGroup {
            ZStack {
                // Użycie koloru z Assets jako tła dla całej aplikacji
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
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
