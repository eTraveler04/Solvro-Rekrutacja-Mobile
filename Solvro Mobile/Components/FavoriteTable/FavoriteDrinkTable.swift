import Foundation
import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favoriteDrinks) { drink in
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
                    .padding(.vertical, 4)
                }
                // Tu dopiero przypisujemy obsługę usuwania wierszy
//                .onDelete(perform: deleteDrink)
            }
            .navigationTitle("Ulubione Drinki")
        }
    }
    
    private func deleteDrink(at offsets: IndexSet) {
        offsets.forEach { index in
            let drink = favoritesManager.favoriteDrinks[index]
            favoritesManager.removeFavorite(drink: drink)
        }
    }
}


struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        // Przykładowe dane dla podglądu
        FavoritesManager.shared.favoriteDrinks = [
            Drink(
                id: 1,
                name: "Mojito",
                category: "Cocktail",
                glass: "Highball glass",
                instructions: "Muddle mint leaves with sugar and lime juice.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 2,
                name: "Martini",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Stir ingredients with ice, strain into a chilled glass.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 3,
                name: "Martini",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Stir ingredients with ice, strain into a chilled glass.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 4,
                name: "Martini",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Stir ingredients with ice, strain into a chilled glass.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 5,
                name: "Martini",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Stir ingredients with ice, strain into a chilled glass.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            ),
            Drink(
                id: 6,
                name: "Martini",
                category: "Cocktail",
                glass: "Cocktail glass",
                instructions: "Stir ingredients with ice, strain into a chilled glass.",
                imageUrl: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
                alcoholic: true,
                createdAt: nil,
                updatedAt: nil
            )
        ]
        return FavoritesListView()
    }
}
