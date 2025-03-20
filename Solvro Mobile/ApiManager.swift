import Foundation

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

struct CocktailListResponse: Codable {
    let meta: Meta
    let data: [Drink]
}

struct IngredientResponse: Codable {
    let data: IngredientData
}

struct IngredientData: Codable {
    let ingredients: [Ingredient]
}

class APIManager {
    static let shared = APIManager()
    
    func fetchDrinks(page: Int = 1, completion: @escaping (Result<CocktailListResponse, Error>) -> Void) {
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
                completion(.success(cocktailResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchSearchedDrinks(query: String, page: Int = 1, completion: @escaping (Result<CocktailListResponse, Error>) -> Void) {
        // Zakodowanie zapytania i dodanie wildcard (np. "nail" -> "%25nail%25")
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let wildcardQuery = "%25\(encodedQuery)%25"
        let urlString = "https://cocktails.solvro.pl/api/v1/cocktails?name=\(wildcardQuery)&page=\(page)"
        print("fetchSearchedDrinks URL: \(urlString)")
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
                completion(.success(cocktailResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchIngredients(drinkId: Int, completion: @escaping (Result<[Ingredient], Error>) -> Void) {
        let urlString = "https://cocktails.solvro.pl/api/v1/cocktails/\(drinkId)"
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
                let wrapper = try JSONDecoder().decode(IngredientResponse.self, from: data)
                completion(.success(wrapper.data.ingredients))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension APIManager {
    func fetchIngredients(for drink: Drink, completion: @escaping (Result<[Ingredient], Error>) -> Void) {
        if let ingredients = drink.ingredients, !ingredients.isEmpty {
            completion(.success(ingredients))
            return
        }
        fetchIngredients(drinkId: drink.id, completion: completion)
    }
}
