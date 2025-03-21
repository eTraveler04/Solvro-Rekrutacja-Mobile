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
        title = "Koktajle" // Włącz mały tytuł
        view.backgroundColor = .white
        
       navigationItem.largeTitleDisplayMode = .always  // Włącz duży tytuł
       navigationController?.navigationBar.prefersLargeTitles = true
        
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
        
        // Customize the search bar's text field
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            // Change placeholder color (e.g., light gray)
            textfield.attributedPlaceholder = NSAttributedString(string: searchController.searchBar.placeholder ?? "", attributes: [
                .foregroundColor: UIColor.lightGray
            ])
            // Change the text color if desired
            textfield.textColor = UIColor.white
            
            // Change the color of the loupe icon (left view)
            if let leftIconView = textfield.leftView as? UIImageView {
                leftIconView.tintColor = UIColor.white
            }
        }
        
        
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
        
        guard let navBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Ustawia nieprzezroczyste tło
        
        if let bgImage = UIImage(named: "CardBackground") {
            appearance.backgroundImage = bgImage
        } else {
            appearance.backgroundColor = UIColor.systemBackground // fallback
        }
        
        // Ustaw tytuł na biały i dodaj przesunięcie w pionie (baselineOffset)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32),
            .baselineOffset: -5  // Dodaje odstęp w pionie – wartość możesz dostosować
        ]
        
        // Styl dużego tytułu
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 36) ?? UIFont.boldSystemFont(ofSize: 38),
            .baselineOffset: 20
        ]
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        searchTableView.frame = view.bounds
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 20, right: 0)
        tableView.contentInset = inset
        searchTableView.contentInset = inset
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.defaultTextAttributes[.foregroundColor] = UIColor.white
        }
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

