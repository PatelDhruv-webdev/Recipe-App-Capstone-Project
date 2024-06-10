import Foundation

class RecipeService {
    static let shared = RecipeService()

    /// Loads recipes from a local JSON file asynchronously.
    func loadRecipes(completion: @escaping ([Recipe]) -> Void) {
        // Use `userInitiated` for user-requested data loading tasks
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
                DispatchQueue.main.async {
                    print("Failed to find JSON file in the bundle.")
                    completion([]) // Callback on the main thread
                }
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    print("Failed to load data from JSON file.")
                    completion([]) // Callback on the main thread
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                // Decoding the JSON data into `Recipe` objects
                let recipes = try decoder.decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    completion(recipes) // Callback on the main thread
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding JSON: \(error)")
                    completion([]) // Callback on the main thread
                }
            }
        }
    }
}

