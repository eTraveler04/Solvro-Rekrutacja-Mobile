import SwiftUI

@main
struct Solvro_MobileApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    let persistenceController = PersistenceController.shared
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    init() {
        AppearanceConfigurator.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainNavigationContainerView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
