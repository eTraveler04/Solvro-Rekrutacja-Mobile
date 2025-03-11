//
//  DrinksViewModel.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import Foundation

// ViewModel odpowiedzialny za pobieranie i przygotowywanie danych do wyświetlenia
class DrinksViewModel {
    
    // Zmienna przechowująca pobrane drinki
    private(set) var drinks: [Drink] = []
    
    // Closure informująca widok o zmianach (np. do przeładowania tabeli)
    var onDataUpdated: (() -> Void)?
    
    // Metoda pobierająca drinki dla danej strony
    func fetchDrinks(page: Int = 1) {
        APIManager.shared.fetchDrinks(page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedDrinks):
                    // Przypisujemy pobrane dane do zmiennej i informujemy widok
                    self?.drinks = fetchedDrinks
                    self?.onDataUpdated?()
                case .failure(let error):
                    // Możesz tutaj obsłużyć błąd – np. wyświetlić alert
                    print("Błąd pobierania drinków: \(error.localizedDescription)")
                }
            }
        }
    }
}
