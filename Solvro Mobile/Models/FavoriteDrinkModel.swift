//
//  FavoriteDrinkSingleton.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 11/03/2025.
//

import Foundation

// Singleton odpowiedzialny za zarządzanie ulubionymi drinkami
class FavoritesManager {
    // Jedyna instancja obiektu dostępna globalnie
    static let shared = FavoritesManager()
    
    // Prywatny initializer zapobiegający tworzeniu nowych instancji
    private init() { }
    
    // Tablica przechowująca ulubione drinki
    var favoriteDrinks: [Drink] = []
    
    // Metoda dodająca drinka do ulubionych (jeśli wcześniej nie został dodany)
    func addFavorite(drink: Drink) {
        guard !favoriteDrinks.contains(where: { $0.id == drink.id }) else { return }
        favoriteDrinks.append(drink)
    }
    
    // Metoda usuwająca drinka z ulubionych
    func removeFavorite(drink: Drink) {
        favoriteDrinks.removeAll(where: { $0.id == drink.id })
    }
    
    // Metoda sprawdzająca, czy dany drink jest ulubionym
    func isFavorite(drink: Drink) -> Bool {
        return favoriteDrinks.contains(where: { $0.id == drink.id })
    }
}
