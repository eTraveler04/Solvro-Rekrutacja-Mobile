import SwiftUI

@main
struct Solvro_MobileApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    let persistenceController = PersistenceController.shared
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        if let bgImage = UIImage(named: "CardBackground") {
            tabBarAppearance.backgroundImage = bgImage
            tabBarAppearance.backgroundColor = .clear
        }
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        UIView.appearance(whenContainedInInstancesOf: [UIHostingController<AnyView>.self]).backgroundColor = UIColor(named: "Background")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        if let bgImage = UIImage(named: "CardBackground") {
            appearance.backgroundImage = bgImage
        } else {
            appearance.backgroundColor = UIColor.systemBackground
        }
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 36) ?? UIFont.boldSystemFont(ofSize: 38),
            .baselineOffset: 20
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32),
            .baselineOffset: -5
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }


    var body: some Scene {
        WindowGroup {
            MainNavigationContainerView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}


//
//@main
//struct Solvro_MobileApp: App {
//    @AppStorage("isDarkMode") var isDarkMode: Bool = false
//    let persistenceController = PersistenceController.shared
//    @ObservedObject var favoritesManager = FavoritesManager.shared
//
//    init() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        if let bgImage = UIImage(named: "CardBackground") {
//            tabBarAppearance.backgroundImage = bgImage
//            tabBarAppearance.backgroundColor = .clear
//        }
//        UITabBar.appearance().standardAppearance = tabBarAppearance
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//
//        UIView.appearance(whenContainedInInstancesOf: [UIHostingController<AnyView>.self]).backgroundColor = UIColor(named: "Background")
//
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        if let bgImage = UIImage(named: "CardBackground") {
//            appearance.backgroundImage = bgImage
//        } else {
//            appearance.backgroundColor = UIColor.systemBackground
//        }
//        appearance.largeTitleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont(name: "Noteworthy-Bold", size: 36) ?? UIFont.boldSystemFont(ofSize: 38),
//            .baselineOffset: 20
//        ]
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont(name: "Noteworthy-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32),
//            .baselineOffset: -5
//        ]
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//    }
//
//
//    var body: some Scene {
//        WindowGroup {
//            ZStack {
//                Color("Background")
//                    .ignoresSafeArea()
//
//                TabView {
//                    FavDrinkCardView()
//                        .tabItem {
//                            Label("", systemImage: "lanyardcard")
//                        }
//
//                    DrinksViewControllerRepresentable()
//                        .tabItem {
//                            Label("", systemImage: "wineglass")
//                        }
//
//                    FavoritesListView()
//                        .tabItem {
//                            Label("", systemImage: "star")
//                        }
//
//                    ThemeSwitcherView(isDarkMode: $isDarkMode)
//                        .tabItem {
//                            Label("", systemImage: "gear")
//                        }
//                }
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .preferredColorScheme(isDarkMode ? .dark : .light)
//            }
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            .preferredColorScheme(isDarkMode ? .dark : .light)
//        }
//    }
//}
