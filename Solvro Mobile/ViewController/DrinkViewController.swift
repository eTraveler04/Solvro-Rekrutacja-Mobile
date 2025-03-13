//
//  DrinkViewController.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import UIKit

class DrinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "DrinkCell")
        view.addSubview(tableView)
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
        
        cell.configure(with: drink)
        
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
