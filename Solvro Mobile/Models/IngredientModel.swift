//
//  IngredientModel.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 18/03/2025.
//

import Foundation

// Model składnika drinka
struct Ingredient: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let alcohol: Bool
    let type: String?
    let percentage: Int?
    let imageUrl: String?
    let createdAt: String?
    let updatedAt: String?
    let measure: String?
}

// Odpowiedź API
struct IngredientResponse: Codable {
    let ingredients: [Ingredient]
}
