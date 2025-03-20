//import UIKit
//import SwiftUI
//
//class DrinksViewController: UIViewController {
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    let tableView = UITableView()                             // Main table for drink list
//    let searchTableView = UITableView()                       // Table for search results
//    let viewModel = DrinksViewModel()
//    var mainTableManager: DrinksTableManager!                 // Manager for main table
//    var searchTableManager: DrinksTableManager!               // Manager for search table
//    let searchController = UISearchController(searchResultsController: nil)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Koktajle"
//        view.backgroundColor = .white
//
//        // Setup both tables, table managers and search controller
//        setupMainTableView()
//        setupSearchTableView()
//        setupTableManagers()
//        setupSearchController()
//        bindViewModel()
//        
//        // Set the closure so that tapping a cell opens the details popup.
//        mainTableManager.didSelectDrink = { [weak self] drink in
//            guard let self = self else { return }
//            let detailsVC = DrinkDetailsViewController(drink: drink)
//            let nav = UINavigationController(rootViewController: detailsVC)
//            nav.modalPresentationStyle = .formSheet
//            self.present(nav, animated: true, completion: nil)
//        }
//        searchTableManager.didSelectDrink = mainTableManager.didSelectDrink
//
//        // Initial loading of data for main table
//        mainTableManager.isLoading = true
//        viewModel.fetchDrinks(page: viewModel.currentPage)
//    }
//    
//    func setupMainTableView() {
//        tableView.frame = view.bounds
//        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
//        view.addSubview(tableView)
//        tableView.isHidden = false   // Show main table by default
//    }
//    
//    func setupSearchTableView() {
//        searchTableView.frame = view.bounds
//        searchTableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
//        view.addSubview(searchTableView)
//        searchTableView.isHidden = true  // Hide search table by default
//    }
//    
//    func setupTableManagers() {
//        // Main table manager
//        mainTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.currentPage += 1
//            self.viewModel.fetchDrinks(page: self.viewModel.currentPage)
//        })
//        tableView.dataSource = mainTableManager
//        tableView.delegate = mainTableManager
//        
//        // Search table manager
//        searchTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.currentSearchPage += 1
//            let query = self.searchController.searchBar.text ?? ""
//            self.viewModel.fetchSearchedDrinks(query: query, page: self.viewModel.currentSearchPage)
//        })
//        searchTableView.dataSource = searchTableManager
//        searchTableView.delegate = searchTableManager
//    }
//    
//    func setupSearchController() {
//        searchController.searchResultsUpdater = self   // Set updater
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Wyszukaj koktajl"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//    }
//    
//    func bindViewModel() {
//        viewModel.onDataUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.searchTableView.reloadData()
//                self?.mainTableManager.loadingCompleted()
//                self?.searchTableManager.loadingCompleted()
//            }
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // Reload data in both tables to reflect any changes.
//        tableView.reloadData()
//        searchTableView.reloadData()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//        searchTableView.frame = view.bounds
//        tableView.contentInset = UIEdgeInsets(
//            top: 0,
//            left: 0,
//            bottom: view.safeAreaInsets.bottom + 20,
//            right: 0
//        )
//        searchTableView.contentInset = tableView.contentInset // Same insets for search table.
//    }
//}
//
//extension DrinksViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let query = searchController.searchBar.text ?? ""
//        print("updateSearchResults called with query: \(query)")
//        if query.isEmpty {
//            // When search text is empty, hide searchTableView and show main tableView
//            searchTableView.isHidden = true
//            tableView.isHidden = false
//            view.bringSubviewToFront(tableView)
//            tableView.reloadData()
//            view.setNeedsLayout()
//        } else {
//            // When using search, show searchTableView and hide main tableView
//            searchTableView.isHidden = false
//            tableView.isHidden = true
//            view.bringSubviewToFront(searchTableView)
//            // Reset pagination and trigger the fetch for search results
//            viewModel.currentSearchPage = 1
//            viewModel.fetchSearchedDrinks(query: query, page: viewModel.currentSearchPage)
//            searchTableView.reloadData()
//            view.setNeedsLayout()
//        }
//    }
//}
//
//// MARK: - SwiftUI Preview
//
//struct DrinksViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UINavigationController {
//        let drinksVC = DrinksViewController()
//        return UINavigationController(rootViewController: drinksVC)
//    }
//    
//    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
//        // Aktualizacje widoku, jeśli są potrzebne
//    }
//}
//
//struct DrinksViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        DrinksViewControllerRepresentable()
//    }
//}

import UIKit
import SwiftUI

class DrinksViewController: UIViewController {
    let tableView = UITableView()                // Główna tabela z listą drinków
    let searchTableView = UITableView()          // Tabela z wynikami wyszukiwania
    let viewModel = DrinksViewModel()
    var mainTableManager: DrinksTableManager!    // Manager dla głównej tabeli
    var searchTableManager: DrinksTableManager!  // Manager dla tabeli wyszukiwania
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Koktajle"
        view.backgroundColor = .white
        
        setupMainTableView()
        setupSearchTableView()
        setupTableManagers()
        setupSearchController()
        bindViewModel()
        
        // Ustawienie akcji przy tapnięciu w komórkę (otwarcie szczegółów drinka)
        mainTableManager.didSelectDrink = { [weak self] drink in
            guard let self = self else { return }
            let detailsVC = DrinkDetailsViewController(drink: drink)
            let nav = UINavigationController(rootViewController: detailsVC)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true, completion: nil)
        }
        // Dla wyszukiwania wykorzystujemy tę samą akcję
        searchTableManager.didSelectDrink = mainTableManager.didSelectDrink
        
        // Początkowe pobranie danych dla głównej tabeli
        mainTableManager.isLoading = true
        viewModel.fetchDrinks(page: viewModel.currentPage)
    }
    
    func setupMainTableView() {
        tableView.frame = view.bounds
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(tableView)
        tableView.isHidden = false   // Główna tabela widoczna domyślnie
    }
    
    func setupSearchTableView() {
        searchTableView.frame = view.bounds
        searchTableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(searchTableView)
        searchTableView.isHidden = true  // Tabela wyszukiwania ukryta domyślnie
    }
    
    func setupTableManagers() {
        // Manager dla głównej tabeli
        mainTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
            guard let self = self else { return }
            self.viewModel.currentPage += 1
            self.viewModel.fetchDrinks(page: self.viewModel.currentPage)
        })
        tableView.dataSource = mainTableManager
        tableView.delegate = mainTableManager
        
        // Manager dla tabeli wyszukiwania
        searchTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
            guard let self = self else { return }
            self.viewModel.currentSearchPage += 1
            let query = self.searchController.searchBar.text ?? ""
            self.viewModel.fetchSearchedDrinks(query: query, page: self.viewModel.currentSearchPage)
        })
        searchTableManager.isSearching = true
        searchTableView.dataSource = searchTableManager
        searchTableView.delegate = searchTableManager
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Wyszukaj koktajl"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.mainTableManager.loadingCompleted()
            }
        }
        viewModel.searchedOnDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
                self?.searchTableManager.loadingCompleted()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        searchTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        searchTableView.frame = view.bounds
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 20, right: 0)
        tableView.contentInset = inset
        searchTableView.contentInset = inset
    }
}

extension DrinksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        if query.isEmpty {
            // Gdy pole wyszukiwania jest puste, pokazujemy główną tabelę
            searchTableView.isHidden = true
            tableView.isHidden = false
            view.bringSubviewToFront(tableView)
            searchTableManager.isSearching = false
            
            // Odświeżamy dane głównej listy, aby zmiany były widoczne
                       viewModel.onDataUpdated?()
        } else {
            // Gdy szukamy, pokazujemy tabelę wyników wyszukiwania
            searchTableView.isHidden = false
            tableView.isHidden = true
            view.bringSubviewToFront(searchTableView)
            searchTableManager.isSearching = true
            viewModel.currentSearchPage = 1
            viewModel.fetchSearchedDrinks(query: query, page: viewModel.currentSearchPage)
        }
    }
}

// MARK: - SwiftUI Preview

struct DrinksViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let drinksVC = DrinksViewController()
        return UINavigationController(rootViewController: drinksVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
}

struct DrinksViewController_Previews: PreviewProvider {
    static var previews: some View {
        DrinksViewControllerRepresentable()
    }
}
