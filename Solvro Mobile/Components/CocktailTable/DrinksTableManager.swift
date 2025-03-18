//
//  DrinksTableManager.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 13/03/2025.
//

import Foundation
import UIKit

class DrinksTableManager: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var viewModel: DrinksViewModel
    var isLoading: Bool = false
    var currentPage: Int = 1
    
    /// Closure wywoływana przy konieczności załadowania kolejnej strony
    var onLoadMore: (() -> Void)?
    
    // New closure to handle row selection
    var didSelectDrink: ((Drink) -> Void)?
    
    init(viewModel: DrinksViewModel, onLoadMore: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onLoadMore = onLoadMore
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkTableViewCell
        let drink = viewModel.drinks[indexPath.row]
        cell.configure(with: drink)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = viewModel.drinks[indexPath.row]
        didSelectDrink?(drink)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate (Infinite Scrolling)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Sprawdzamy, czy jesteśmy blisko końca listy
        if offsetY > contentHeight - height - 100, !isLoading {
            // Sprawdzamy, czy lastPage jest dostępny i czy nie osiągnęliśmy końca
            if let lastPage = viewModel.lastPage, currentPage >= lastPage {
                return
            }
            isLoading = true
            currentPage += 1
            onLoadMore?()
        }
    }

    
    // Metoda wywoływana po zakończeniu ładowania danych
    func loadingCompleted() {
        isLoading = false
    }
}
