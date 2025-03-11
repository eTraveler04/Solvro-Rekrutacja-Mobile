//
//  ApiManager.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 10/03/2025.
//

import Foundation

// Model Meta do przechowywania metadanych odpowiedzi
struct Meta: Codable {
    let total: Int
    let perPage: Int
    let currentPage: Int
    let lastPage: Int
    let firstPage: Int
    let firstPageUrl: String
    let lastPageUrl: String
    let nextPageUrl: String?
    let previousPageUrl: String?
}

// Odpowiedź API zawierająca metadane oraz listę drinków
struct CocktailListResponse: Codable {
    let meta: Meta
    let data: [Drink]
}

// APIManager - warstwa Service
class APIManager {
    static let shared = APIManager()
    
    /// Pobiera listę drinków dla podanej strony.
    /// - Parameters:
    ///   - page: Numer strony, domyślnie 1.
    ///   - completion: Blok zwrotny z wynikiem (sukces lub błąd).
    func fetchDrinks(page: Int = 1, completion: @escaping (Result<[Drink], Error>) -> Void) {
        let urlString = "https://cocktails.solvro.pl/api/v1/cocktails/?page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let cocktailResponse = try JSONDecoder().decode(CocktailListResponse.self, from: data)
                // Przekazujemy tylko tablicę drinków
                completion(.success(cocktailResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
