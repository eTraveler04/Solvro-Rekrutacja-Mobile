//
//  AppearanceConfigurator.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 22/03/2025.
//

import UIKit
import SwiftUI

struct AppearanceConfigurator {
    static func configure() {
        // Configure Tab Bar appearance.
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        if let bgImage = UIImage(named: "CardBackground") {
            tabBarAppearance.backgroundImage = bgImage
            tabBarAppearance.backgroundColor = .clear
        }
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configure UIHostingController background for SwiftUI views.
        UIView.appearance(whenContainedInInstancesOf: [UIHostingController<AnyView>.self]).backgroundColor = UIColor(named: "Background")
        
        // Configure Navigation Bar appearance.
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        if let bgImage = UIImage(named: "CardBackground") {
            navAppearance.backgroundImage = bgImage
        } else {
            navAppearance.backgroundColor = UIColor.systemBackground
        }
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 36) ?? UIFont.boldSystemFont(ofSize: 38),
            .baselineOffset: -10
        ]
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32),
            .baselineOffset: -10
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }
}
