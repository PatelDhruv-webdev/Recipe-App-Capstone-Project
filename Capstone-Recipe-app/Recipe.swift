import Foundation

struct Recipe: Codable {
    var title: String
    var description: String
    var imageName: String
    var ingredients: [Ingredient]
}

struct Ingredient: Codable {
    var name: String
    var quantity: Double
    var unit: String
}

