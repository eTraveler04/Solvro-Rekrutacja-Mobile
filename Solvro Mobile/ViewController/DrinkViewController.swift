import UIKit
import SwiftUI

class DrinksViewController: UIViewController {
    @Environment(\.managedObjectContext) private var viewContext
    
    let tableView = UITableView()
    let viewModel = DrinksViewModel()
    var tableManager: DrinksTableManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Koktajle"
        view.backgroundColor = .white
        
        setupTableView()
        setupTableManager()
        bindViewModel()
        
        // Inicjalne ładowanie danych - ustawiamy stan ładowania i pobieramy pierwszą stronę
        tableManager.isLoading = true
        viewModel.fetchDrinks(page: tableManager.currentPage)
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(tableView)
    }
    
    func setupTableManager() {
        tableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchDrinks(page: self.tableManager.currentPage)
        })
        tableView.dataSource = tableManager
        tableView.delegate = tableManager
    }
    
    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableManager.loadingCompleted()
            }
        }
    }
}

// MARK: - SwiftUI Preview

struct DrinksViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DrinksViewController {
        return DrinksViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrinksViewController, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}

struct DrinksViewController_Previews: PreviewProvider {
    static var previews: some View {
        DrinksViewControllerRepresentable()
    }
}
