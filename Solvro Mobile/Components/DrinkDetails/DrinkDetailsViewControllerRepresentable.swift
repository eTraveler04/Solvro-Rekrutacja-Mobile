//
//  DrinkDetailsViewControllerRepresentable.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 18/03/2025.
//

import SwiftUI
import UIKit

struct DrinkDetailsViewControllerRepresentable: UIViewControllerRepresentable {
    let drink: Drink

    func makeUIViewController(context: Context) -> UIViewController {
        // Create the details view controller.
        let detailsVC = DrinkDetailsViewController(drink: drink)
        // Configure the Done button if not already set.
        detailsVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                   target: detailsVC,
                                                                   action: #selector(detailsVC.closeTapped))
        // Wrap the details view controller in a UINavigationController so that the navigation bar (and dark mode) is handled automatically.
        let navController = UINavigationController(rootViewController: detailsVC)
        return navController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed.
    }
}
