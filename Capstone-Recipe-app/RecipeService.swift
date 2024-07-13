import Foundation

class RecipeService {
    static let shared = RecipeService()

    func loadRecipes(completion: @escaping ([Recipe]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
                DispatchQueue.main.async {
                    print("Failed to find JSON file in the bundle.")
                    completion([])
                }
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    print("Failed to load data from JSON file.")
                    completion([])
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let recipes = try decoder.decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    completion(recipes)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding JSON: \(error)")
                    completion([])
                }
            }
        }
    }
}
