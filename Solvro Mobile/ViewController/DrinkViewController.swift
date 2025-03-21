//
//  ExampleView.swift
//  SomeProject
//
//  Created by You on 3/20/25.
//

import UIKit
import SwiftUI

class DrinksViewController: UIViewController {
    // MARK: - Properties
    let tableView = UITableView()                // Main table view
    let searchTableView = UITableView()          // Table view for search results
    let viewModel = DrinksViewModel()
    var mainTableManager: DrinksTableManager!    // Manager for main table
    var searchTableManager: DrinksTableManager!  // Manager for search results table
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Koktajle"
        
        configureNavigationBar()
        setupTableViews()
        setupTableManagers()
        configureSearchController()
        configureSearchDelegates()
        bindViewModel()
        configureTableManagersSelection()
        
        // Initial fetch for main table.
        mainTableManager.isLoading = true
        viewModel.fetchDrinks(page: viewModel.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset search controller state if active.
        if searchController.isActive {
            searchController.searchBar.text = ""
            searchController.isActive = false
            view.endEditing(true)
        }
        
        // Ensure main table is visible.
        tableView.isHidden = false
        searchTableView.isHidden = true
        view.bringSubviewToFront(tableView)
        
        // Reload tables to update states like star fill.
        tableView.reloadData()
        searchTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        searchTableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.defaultTextAttributes[.foregroundColor] = UIColor.white
        }
    }
    
    // MARK: - Configuration Methods
    private func configureNavigationBar() {
        // Set large title settings.
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupTableViews() {
        // Setup main table view.
        tableView.frame = view.bounds
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(tableView)
        tableView.isHidden = false
        
        // Setup search results table view.
        searchTableView.frame = view.bounds
        searchTableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(searchTableView)
        searchTableView.isHidden = true
    }
    
    private func setupTableManagers() {
        // Configure main table manager.
        mainTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
            guard let self = self else { return }
            self.viewModel.currentPage += 1
            self.viewModel.fetchDrinks(page: self.viewModel.currentPage)
        })
        tableView.dataSource = mainTableManager
        tableView.delegate = mainTableManager
        
        // Configure search table manager.
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
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Wyszukaj koktajl"
        
        // Customize search bar's text field.
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(
                string: searchController.searchBar.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.lightGray]
            )
            textfield.textColor = .white
            if let leftIconView = textfield.leftView as? UIImageView {
                leftIconView.tintColor = .white
            }
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureSearchDelegates() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func bindViewModel() {
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
    
    private func configureTableManagersSelection() {
        let selectionHandler: (Drink) -> Void = { [weak self] drink in
            guard let self = self else { return }
            let detailsVC = DrinkDetailsViewController(drink: drink)
            let nav = UINavigationController(rootViewController: detailsVC)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true, completion: nil)
        }
        mainTableManager.didSelectDrink = selectionHandler
        searchTableManager.didSelectDrink = selectionHandler
    }
}

// MARK: - UISearchResultsUpdating
extension DrinksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        if query.isEmpty {
            // When search field is empty, show main table.
            searchTableView.isHidden = true
            tableView.isHidden = false
            view.bringSubviewToFront(tableView)
            searchTableManager.isSearching = false
            viewModel.onDataUpdated?()
        } else {
            // When user is searching, display search results table.
            searchTableView.isHidden = false
            tableView.isHidden = true
            view.bringSubviewToFront(searchTableView)
            searchTableManager.isSearching = true
            viewModel.currentSearchPage = 1
            viewModel.fetchSearchedDrinks(query: query, page: viewModel.currentSearchPage)
        }
    }
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate
extension DrinksViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            let offset = CGPoint(x: 0, y: -self.tableView.adjustedContentInset.top)
            self.tableView.setContentOffset(offset, animated: true)
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            let offset = CGPoint(x: 0, y: -self.tableView.adjustedContentInset.top)
            self.tableView.setContentOffset(offset, animated: true)
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
