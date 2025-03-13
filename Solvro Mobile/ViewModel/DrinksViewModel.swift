//
//  DrinksViewModel.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import Foundation

// ViewModel odpowiedzialny za pobieranie i przygotowywanie danych do wyświetlenia
class DrinksViewModel {
    var drinks: [Drink] = []
    var lastPage: Int?
    var onDataUpdated: (() -> Void)?
    
    func fetchDrinks(page: Int) {
        APIManager.shared.fetchDrinks(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                // Zapisujemy informację o ostatniej stronie
                self?.lastPage = response.meta.lastPage
                // Dołączamy nowe drinki
                self?.drinks.append(contentsOf: response.data)
                self?.onDataUpdated?()
            case .failure(let error):
                print("Błąd podczas pobierania drinków: \(error)")
            }
        }
    }
}
