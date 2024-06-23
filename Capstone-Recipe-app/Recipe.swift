import Foundation

struct Recipe: Codable {
    var title: String
    var description: String
    var imageName: String
    var ingredients: [Ingredient]
//    var category: String
}

struct Ingredient: Codable {
    var name: String
    var quantities: [String: Double]
    var unit: String
}
