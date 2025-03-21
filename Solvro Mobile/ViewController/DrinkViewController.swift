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
        
        // Usuwamy ręczne zarządzanie wcięciami.
        // extendedLayoutIncludesOpaqueBars = true
        // additionalSafeAreaInsets.top = 35
        
        title = "Koktajle"
        view.backgroundColor = .white
        
        // Włącz duży tytuł
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupMainTableView()
        setupSearchTableView()
        setupTableManagers()
        setupSearchController()
        
        // Delegaci searchControllera i searchBar
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
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
            // Zmiana koloru placeholdera (np. jasnoszary)
            textfield.attributedPlaceholder = NSAttributedString(string: searchController.searchBar.placeholder ?? "", attributes: [
                .foregroundColor: UIColor.lightGray
            ])
            // Zmiana koloru tekstu, jeśli potrzeba
            textfield.textColor = UIColor.white
            
            // Zmiana koloru ikony lupy (left view)
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
        
        // Jeśli searchController jest aktywny, wyczyść tekst i dezaktywuj go.
        if searchController.isActive {
            searchController.searchBar.text = ""
            searchController.isActive = false
            view.endEditing(true)
        }
        
        // Upewnij się, że główna tabela jest widoczna.
        tableView.isHidden = false
        searchTableView.isHidden = true
        view.bringSubviewToFront(tableView)
        
        // Odśwież widok tabel, aby zaktualizować status gwiazdek itp.
        tableView.reloadData()
        searchTableView.reloadData()
        
        // Pozostawiamy domyślne zachowanie iOS co do insets
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Ustawiamy ramki na cały widok
        tableView.frame = view.bounds
        searchTableView.frame = view.bounds
        
        // Nie manipulujemy ujemnym top inset
        // i pozwalamy iOS kontrolować wcięcia pod duży tytuł i search bar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Upewniamy się, że kolor tekstu w polu wyszukiwania jest biały
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.defaultTextAttributes[.foregroundColor] = UIColor.white
        }
    }
}

// MARK: - UISearchResultsUpdating
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
            // Gdy wyszukujemy, pokazujemy tabelę wyników wyszukiwania
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
    
    // Metoda wywoływana, gdy użytkownik kliknie Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Jeśli chcesz dodatkowo wymusić offset tabeli, możesz zrobić to tutaj:
        DispatchQueue.main.async {
            // Przykład: offset na (0,0) lub inny dopasowany do layoutu
            self.tableView.setContentOffset(.zero, animated: false)
        }
    }
    
    // Metoda wywoływana po całkowitym „zwinięciu” searchControllera
    func didDismissSearchController(_ searchController: UISearchController) {
        // Możesz również tu zresetować offset, jeśli jest taka potrzeba.
        // self.tableView.setContentOffset(.zero, animated: false)
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
