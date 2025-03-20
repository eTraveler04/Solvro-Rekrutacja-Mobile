import Foundation
import UIKit

class DrinksTableManager: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var viewModel: DrinksViewModel
    var isLoading: Bool = false
    var isSearching: Bool = false  // Wskazuje, czy manager obsługuje wyniki wyszukiwania
    
    /// Closure wywoływana przy konieczności załadowania kolejnej strony
    var onLoadMore: (() -> Void)?
    
    // Closure do obsługi wyboru wiersza
    var didSelectDrink: ((Drink) -> Void)?
    
    init(viewModel: DrinksViewModel, onLoadMore: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onLoadMore = onLoadMore
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return viewModel.searchedDrinks.count
        } else {
            return viewModel.drinks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkTableViewCell
        let drink: Drink
        if isSearching {
            drink = viewModel.searchedDrinks[indexPath.row]
        } else {
            drink = viewModel.drinks[indexPath.row]
        }
        cell.configure(with: drink)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink: Drink
        if isSearching {
            drink = viewModel.searchedDrinks[indexPath.row]
        } else {
            drink = viewModel.drinks[indexPath.row]
        }
        didSelectDrink?(drink)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate (Infinite Scrolling)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100, !isLoading {
            if isSearching {
                if let lastPage = viewModel.searchedLastPage, viewModel.currentSearchPage >= lastPage {
                    return
                }
                viewModel.currentSearchPage += 1
            } else {
                if let lastPage = viewModel.lastPage, viewModel.currentPage >= lastPage {
                    return
                }
                viewModel.currentPage += 1
            }
            isLoading = true
            onLoadMore?()
        }
    }
    
    func loadingCompleted() {
        isLoading = false
    }
}
