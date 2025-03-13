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
    
    // MARK: - UIScrollViewDelegate (Infinite Scrolling)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Jeżeli użytkownik zbliża się do końca listy i nie trwa ładowanie, pobierz kolejną stronę
        if offsetY > contentHeight - height - 100, !isLoading {
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
