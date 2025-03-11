//
//  DrinkViewController.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import UIKit

class DrinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let viewModel = DrinksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Koktajle"
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.fetchDrinks(page: 1)
    }
    
//    func setupTableView() {
//        tableView.frame = view.bounds
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
//        view.addSubview(tableView)
//    }
//    
    func setupTableView() {
        // Wyłącz AutoResizingMask, aby użyć Auto Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        
        view.addSubview(tableView)
        
        // Ustawienie constraints - wyśrodkowanie i rozmiar 80% widoku
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        ])
    }

    func bindViewModel() {
        // Ustawiamy closure, które wywołamy po pobraniu danych
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkTableViewCell
        let drink = viewModel.drinks[indexPath.row]
        
        cell.drinkNameLabel.text = drink.name
        cell.drinkImageView.image = nil
        
        if let url = URL(string: drink.imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let updateCell = tableView.cellForRow(at: indexPath) as? DrinkTableViewCell {
                            updateCell.drinkImageView.image = image
                        }
                    }
                }
            }.resume()
        }
        return cell
    }
}

import SwiftUI

struct DrinksViewController_Previews: PreviewProvider {
    static var previews: some View {
        DrinksViewControllerRepresentable()
    }
}

struct DrinksViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DrinksViewController {
        return DrinksViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrinksViewController, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}
