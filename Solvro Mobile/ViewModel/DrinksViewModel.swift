////
////  DrinksViewModel.swift
////  Solvro Mobile
////
////  Created by Szymon Protynski on 10/03/2025.
////
//
//import Foundation
//
//// ViewModel odpowiedzialny za pobieranie i przygotowywanie danych do wyświetlenia
//class DrinksViewModel {
//    // Drinks related properties
//    var drinks: [Drink] = []
//    var lastPage: Int?
//    var onDataUpdated: (() -> Void)?
//    var currentPage: Int = 1
//
//    // SearchBar related properties
//    var searchedDrinks: [Drink] = []
//    var searchedLastPage: Int?
//    var searchedOnDataUpdated: (() -> Void)?
//    var currentSearchPage: Int = 1
//
//    
//    func fetchDrinks(page: Int) {
//        APIManager.shared.fetchDrinks(page: page) { [weak self] result in
//            switch result {
//            case .success(let response):
//                // Zapisujemy informację o ostatniej stronie
//                self?.lastPage = response.meta.lastPage
//                // Dołączamy nowe drinki
//                self?.drinks.append(contentsOf: response.data)
//                self?.onDataUpdated?()
//            case .failure(let error):
//                print("Błąd podczas pobierania drinków: \(error)")
//            }
//        }
//    }
//    func fetchSearchedDrinks(query: String, page: Int) {
//        APIManager.shared.fetchSearchedDrinks(query: query, page: page) { [weak self] result in
//            switch result {
//            case .success(let response):
//                self?.searchedLastPage = response.meta.lastPage
//                if page == 1 {
//                    // Przy pierwszej stronie nadpisujemy poprzednie wyniki
//                    self?.searchedDrinks = response.data
//                } else {
//                    // Kolejne strony dodajemy do istniejących wyników
//                    self?.searchedDrinks.append(contentsOf: response.data)
//                }
//                self?.searchedOnDataUpdated?()
//            case .failure(let error):
//                print("Błąd podczas pobierania wyszukanych drinków: \(error)")
//            }
//        }
//    }
//}

import Foundation

class DrinksViewModel {
    // Właściwości związane z główną listą drinków
    var drinks: [Drink] = []
    var lastPage: Int?
    var onDataUpdated: (() -> Void)?
    var currentPage: Int = 1

    // Właściwości związane z wyszukiwaniem
    var searchedDrinks: [Drink] = []
    var searchedLastPage: Int?
    var searchedOnDataUpdated: (() -> Void)?
    var currentSearchPage: Int = 1
    
    func fetchDrinks(page: Int) {
        APIManager.shared.fetchDrinks(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.lastPage = response.meta.lastPage
                self?.drinks.append(contentsOf: response.data)
                self?.onDataUpdated?()
            case .failure(let error):
                print("Błąd podczas pobierania drinków: \(error)")
            }
        }
    }
    
    func fetchSearchedDrinks(query: String, page: Int) {
        APIManager.shared.fetchSearchedDrinks(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.searchedLastPage = response.meta.lastPage
                if page == 1 {
                    self?.searchedDrinks = response.data
                } else {
                    self?.searchedDrinks.append(contentsOf: response.data)
                }
                self?.searchedOnDataUpdated?()
                // Możesz też wywołać onDataUpdated, jeśli chcesz zaktualizować wspólny interfejs
                self?.onDataUpdated?()
            case .failure(let error):
                print("Błąd podczas pobierania wyszukanych drinków: \(error)")
            }
        }
    }
}
