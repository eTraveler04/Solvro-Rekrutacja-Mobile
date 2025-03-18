import Foundation
import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared

    // Local copy to display. This lets the list remain unchanged until deletion is confirmed.
    @State private var displayDrinks: [Drink] = []
    // State for the selected drink to show details.
    @State private var selectedDrink: Drink? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(displayDrinks) { drink in
                    HStack(spacing: 16) {
                        if let url = URL(string: drink.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(drink.name)
                                .font(.headline)
                            Text(drink.category)
                                .font(.subheadline)
                            Text(drink.glass)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if favoritesManager.isFavorite(drink: drink) {
                                favoritesManager.removeFavorite(drink: drink)
                            } else {
                                favoritesManager.addFavorite(drink: drink)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(drink: drink) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    // Make the whole row tappable for the popup.
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDrink = drink
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteDrink)
            }
            .navigationTitle("Ulubione Drinki")
            .onAppear {
                displayDrinks = favoritesManager.favoriteDrinks
            }
            // Present the drink details popup when a drink is selected.
            .sheet(item: $selectedDrink) { drink in
                DrinkDetailsViewControllerRepresentable(drink: drink)
            }
        }
    }
    
    private func deleteDrink(at offsets: IndexSet) {
            offsets.forEach { index in
                let drink = displayDrinks[index]
                favoritesManager.removeFavorite(drink: drink)
            }
        }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        // Przykładowe dane dla podglądu
        FavoritesManager.shared.favoriteDrinks = [
            Drink(
                id: 10,
                name: "Long Island Iced Tea",
                category: "Cocktail",
                glass: "Highball glass",
                instructions: "Mix vodka, tequila, rum, gin, triple sec, lemon juice, and simple syrup over ice. Top with cola and garnish with a lemon slice.",
                imageUrl: "https://example.com/long-island-iced-tea.jpg",
                alcoholic: true,
                ingredients: [
                    Ingredient(
                        id: 1,
                        name: "Vodka",
                        description: "A clear distilled alcoholic beverage made from fermented grains or potatoes.",
                        alcohol: true,
                        type: "Vodka",
                        percentage: 40,
                        imageUrl: "https://example.com/vodka.png",
                        createdAt: nil,
                        updatedAt: nil,
                        measure: "1/2 oz"
                    ),
                    Ingredient(
                        id: 2,
                        name: "Tequila",
                        description: "A distilled beverage made from the blue agave plant, typically 40% ABV.",
                        alcohol: true,
                        type: "Spirit",
                        percentage: 40,
                        imageUrl: "https://example.com/tequila.png",
                        createdAt: nil,
                        updatedAt: nil,
                        measure: "1/2 oz"
                    )
                ],
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 11,
                name: "Cosmopolitan",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Add cranberry juice, triple sec, vodka, and a squeeze of lime juice to a shaker with ice. Shake well and strain into a chilled cocktail glass.",
                imageUrl: "https://example.com/cosmopolitan.jpg",
                alcoholic: true,
                ingredients: nil, // brak składników, bo to pole jest opcjonalne
                createdAt: nil,
                updatedAt: nil
            )


        ]
        return FavoritesListView()
    }
}
