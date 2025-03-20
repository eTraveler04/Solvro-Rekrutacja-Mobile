import SwiftUI

enum SwipeDirection {
    case left, right
}

struct DrinkCardView: View {
    let drink: Drink
    var onSwipe: ((SwipeDirection) -> Void)? // Callback informujący rodzica o kierunku swipe

    @State private var offset = CGSize.zero
    @State private var color: Color = .white

    var body: some View {
        // Define a common drag gesture closure to reuse in both cases.
        let dragGesture = DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation {
                    color = offset.width > 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
                }
            }
            .onEnded { _ in
                let threshold: CGFloat = 50
                // Sprawdzamy, czy przesunięcie przekroczyło próg
                if abs(offset.width) > threshold {
                    let direction: SwipeDirection = offset.width > 0 ? .right : .left
                    // Animacja przesunięcia karty poza ekran
                    withAnimation(.easeOut(duration: 0.3)) {
                        offset.width = direction == .right ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
                    }
                    // Po zakończeniu animacji wywołaj callback i zresetuj stan
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onSwipe?(direction)
                        withAnimation {
                            offset = .zero
                            color = .white
                        }
                    }
                } else {
                    // Jeśli przesunięcie nie przekroczyło progu, powrót do stanu początkowego
                    withAnimation {
                        offset = .zero
                        color = .white
                    }
                }
            }

        // Check if drink.id == -1, display only the image.
        if drink.id == -1 {
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(color)
                        .shadow(radius: 10)
                    Image("DefaultCard")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 340, maxHeight: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .frame(height: 500)                  // Ustala wysokość karty
                .frame(maxWidth: .infinity)          // Zapewnia, że karta zajmuje całą szerokość kontenera
                .padding(.horizontal, 20)            // Dodaje marginesy z lewej i prawej
                .offset(x: offset.width, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 40)))
                .gesture(dragGesture)
            )
        } else {
            // Karta z pełnymi danymi + tło z assetów (bez nakładki koloru)
            return AnyView(
                ZStack {
                    // TŁO: obrazek z assetów
                    Image("CardBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 340, maxHeight: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    
                    // ZAWARTOŚĆ KARTY
                    VStack(alignment: .leading, spacing: 5) {
                        Spacer()

                        if let url = URL(string: drink.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .frame(maxWidth: .infinity)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 130, height: 130)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        Text(drink.name)
                            .font(.custom("Noteworthy-Bold", size: 32))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        Spacer()
                    }
                    .padding(25)
                }
                .frame(height: 500)                 // Rozmiar taki sam jak dla id == -1
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .offset(x: offset.width, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 40)))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                            // Usuwamy zmianę koloru – tło pozostaje obrazkiem
                        }
                        .onEnded { _ in
                            let threshold: CGFloat = 50
                            if abs(offset.width) > threshold {
                                let direction: SwipeDirection = offset.width > 0 ? .right : .left
                                withAnimation(.easeOut(duration: 0.3)) {
                                    offset.width = direction == .right ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSwipe?(direction)
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            } else {
                                withAnimation {
                                    offset = .zero
                                }
                            }
                        }
                )
            )
        }

    }
}

#Preview {
    DrinkCardView(
        drink: Drink(
            id: 1,
            name: "Cosmopolitan",
            category: "Cocktail",
            glass: "Cocktail glass",
            instructions: "Add cranberry juice, triple sec, vodka, and a squeeze of lime juice to a shaker with ice. Shake well and strain into a chilled cocktail glass.",
            imageUrl: "https://example.com/cosmopolitan.jpg",
            alcoholic: true,
            ingredients: nil,
            createdAt: nil,
            updatedAt: nil
        )
    ) {
        direction in
        // Obsługa callbacku w podglądzie (Preview)
        print("Swiped \(direction)")
    }
    .padding()
}

//import UIKit
//import SwiftUI
//
//class DrinksViewController: UIViewController {
//    let tableView = UITableView()                // Główna tabela z listą drinków
//    let searchTableView = UITableView()          // Tabela z wynikami wyszukiwania
//    let viewModel = DrinksViewModel()
//    var mainTableManager: DrinksTableManager!    // Manager dla głównej tabeli
//    var searchTableManager: DrinksTableManager!  // Manager dla tabeli wyszukiwania
//    let searchController = UISearchController(searchResultsController: nil)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        // Ustaw tło nawigacji – pełna szerokość u góry
//        setupNavigationBarBackground()
//        
//        title = "Koktajle"
//        
//        setupMainTableView()
//        setupSearchTableView()
//        setupTableManagers()
//        setupSearchController()
//        bindViewModel()
//        
//        // Ustawienie akcji przy tapnięciu w komórkę (otwarcie szczegółów drinka)
//        mainTableManager.didSelectDrink = { [weak self] drink in
//            guard let self = self else { return }
//            let detailsVC = DrinkDetailsViewController(drink: drink)
//            let nav = UINavigationController(rootViewController: detailsVC)
//            nav.modalPresentationStyle = .formSheet
//            self.present(nav, animated: true, completion: nil)
//        }
//        // Dla wyszukiwania wykorzystujemy tę samą akcję
//        searchTableManager.didSelectDrink = mainTableManager.didSelectDrink
//        
//        // Początkowe pobranie danych dla głównej tabeli
//        mainTableManager.isLoading = true
//        viewModel.fetchDrinks(page: viewModel.currentPage)
//    }
//    
//    func setupNavigationBarBackground() {
//        guard let navController = navigationController else { return }
//        
//        // Ustaw nawigację jako przezroczystą
//        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navController.navigationBar.shadowImage = UIImage()
//        navController.navigationBar.isTranslucent = true
//        
//        // Oblicz wysokość obszaru nawigacji (status bar + navigation bar)
//        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
//        let navBarHeight = navController.navigationBar.frame.height
//        let totalHeight = statusBarHeight + navBarHeight
//        
//        // Dodaj obraz tła, który rozciągnie się na całą szerokość i wysokość totalHeight
//        let bgImageView = UIImageView(image: UIImage(named: "CardBackground"))
//        bgImageView.contentMode = .scaleAspectFill
//        bgImageView.clipsToBounds = true
//        bgImageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bgImageView)
//        view.sendSubviewToBack(bgImageView)
//        NSLayoutConstraint.activate([
//            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
//            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bgImageView.heightAnchor.constraint(equalToConstant: totalHeight)
//        ])
//        
//        // Ustaw tytuł w pasku nawigacji jako prostą etykietę
//        let titleLabel = UILabel()
//        titleLabel.text = "Koktajle"
//        titleLabel.font = UIFont(name: "Noteworthy-Bold", size: 32)
//        titleLabel.textColor = .white
//        titleLabel.textAlignment = .center
//        navigationItem.titleView = titleLabel
//    }
//    
//    func setupMainTableView() {
//        tableView.frame = view.bounds
//        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
//        view.addSubview(tableView)
//        tableView.isHidden = false   // Główna tabela widoczna domyślnie
//    }
//    
//    func setupSearchTableView() {
//        searchTableView.frame = view.bounds
//        searchTableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
//        view.addSubview(searchTableView)
//        searchTableView.isHidden = true  // Tabela wyszukiwania ukryta domyślnie
//    }
//    
//    func setupTableManagers() {
//        // Manager dla głównej tabeli
//        mainTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.currentPage += 1
//            self.viewModel.fetchDrinks(page: self.viewModel.currentPage)
//        })
//        tableView.dataSource = mainTableManager
//        tableView.delegate = mainTableManager
//        
//        // Manager dla tabeli wyszukiwania
//        searchTableManager = DrinksTableManager(viewModel: viewModel, onLoadMore: { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.currentSearchPage += 1
//            let query = self.searchController.searchBar.text ?? ""
//            self.viewModel.fetchSearchedDrinks(query: query, page: self.viewModel.currentSearchPage)
//        })
//        searchTableManager.isSearching = true
//        searchTableView.dataSource = searchTableManager
//        searchTableView.delegate = searchTableManager
//    }
//    
//    func setupSearchController() {
//        searchController.searchResultsUpdater = self
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
//                self?.mainTableManager.loadingCompleted()
//            }
//        }
//        viewModel.searchedOnDataUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.searchTableView.reloadData()
//                self?.searchTableManager.loadingCompleted()
//            }
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//        searchTableView.reloadData()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//        searchTableView.frame = view.bounds
//        let inset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 20, right: 0)
//        tableView.contentInset = inset
//        searchTableView.contentInset = inset
//    }
//}
//
//extension DrinksViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let query = searchController.searchBar.text ?? ""
//        if query.isEmpty {
//            // Gdy pole wyszukiwania jest puste, pokazujemy główną tabelę
//            searchTableView.isHidden = true
//            tableView.isHidden = false
//            view.bringSubviewToFront(tableView)
//            searchTableManager.isSearching = false
//            
//            // Odświeżamy dane głównej listy, aby zmiany były widoczne
//            viewModel.onDataUpdated?()
//        } else {
//            // Gdy szukamy, pokazujemy tabelę wyników wyszukiwania
//            searchTableView.isHidden = false
//            tableView.isHidden = true
//            view.bringSubviewToFront(searchTableView)
//            searchTableManager.isSearching = true
//            viewModel.currentSearchPage = 1
//            viewModel.fetchSearchedDrinks(query: query, page: viewModel.currentSearchPage)
//        }
//    }
//}
//
//// MARK: - SwiftUI Preview
//struct DrinksViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UINavigationController {
//        let drinksVC = DrinksViewController()
//        return UINavigationController(rootViewController: drinksVC)
//    }
//    
//    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
//}
//
//struct DrinksViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        DrinksViewControllerRepresentable()
//    }
//}
