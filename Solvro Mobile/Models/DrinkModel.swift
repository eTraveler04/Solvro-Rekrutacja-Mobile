//
//  DrinkModel.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import Foundation

// Model drinka zgodny z API
struct Drink: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let glass: String
    let instructions: String
    let imageUrl: String
    let alcoholic: Bool
    let ingredients: [Ingredient]?
    let createdAt: String?
    let updatedAt: String?
}

// Odpowiedź API
struct DrinkResponse: Codable {
    let drinks: [Drink]
}
