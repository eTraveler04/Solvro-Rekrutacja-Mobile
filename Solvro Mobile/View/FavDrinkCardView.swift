import SwiftUI

struct FavDrinkCardView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared
    @State private var currentIndex = 0

    var body: some View {
        let drinks = favoritesManager.favoriteDrinks
        // Define a default drink
        let defaultDrink = Drink(
            id: -1,
            name: "Dodaj Drinka do ulubionych!",
            category: "No Category",
            glass: "No Glass",
            instructions: "No favorite drinks available",
            imageUrl: "",
            alcoholic: false,
            ingredients: nil,
            createdAt: nil,
            updatedAt: nil
        )
        
        Group {
            if drinks.isEmpty {
                // Display default card if there are no favorite drinks.
                DrinkCardView(drink: defaultDrink, onSwipe: { _ in })
                    .padding(.horizontal, 20)
            } else {
                DrinkCardView(drink: drinks[currentIndex], onSwipe: { direction in
                    withAnimation {
                        switch direction {
                        case .right:
                            // Przesunięcie w prawo – przechodzimy do następnego drinka
                            // Move right: if at last index, loop to beginning.
                            if currentIndex < drinks.count - 1 {
                                currentIndex += 1
                            } else {
                                currentIndex = 0
                            }
                        case .left:
                            // Przesunięcie w lewo – przechodzimy do poprzedniego drinka
                            // Remove current drink and adjust index if out of bounds.
                            favoritesManager.removeFavorite(drink: drinks[currentIndex])
                            let updatedDrinks = favoritesManager.favoriteDrinks
                            if updatedDrinks.isEmpty {
                                currentIndex = 0
                            } else if currentIndex >= updatedDrinks.count {
                                currentIndex = updatedDrinks.count - 1
                            }
                        }
                    }
                })
                .id(currentIndex) // Aktualizacja widoku przy zmianie indeksu
                .padding(.horizontal, 20) // Dodany margines po bokach
            }
        }
    }
}

#Preview {
    FavDrinkCardView()
        .padding()
}
