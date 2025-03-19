import SwiftUI

@main
struct Solvro_MobileApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    let persistenceController = PersistenceController.shared
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "Background")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Ustawienie tła dla UIHostingController, aby reszta widoku miała kolor z Assets.
        UIView.appearance(whenContainedInInstancesOf: [UIHostingController<AnyView>.self]).backgroundColor = UIColor(named: "Background")
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.backgroundColor = UIColor(named: "Background")
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
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
