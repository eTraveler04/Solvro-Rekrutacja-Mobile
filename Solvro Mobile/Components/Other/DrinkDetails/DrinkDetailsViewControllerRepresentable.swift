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
        
        // Configure the right bar button item if not already set in DrinkDetailsViewController.
        // Assumes that DrinkDetailsViewController has a @objc method named closeTapped that dismisses it.
        detailsVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: detailsVC, action: #selector(detailsVC.closeTapped))
        
        // Embed it in a UINavigationController so the navigation bar (with Done button) appears.
        let navController = UINavigationController(rootViewController: detailsVC)
        return navController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed.
    }
}
