import Foundation

struct Nutrition: Codable {
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
}

struct Ingredient: Codable {
    var name: String
    var quantities: [String: Double]
    var unit: String
}

struct Recipe: Codable {
    var title: String
    var description: String
    var imageName: String
    var ingredients: [Ingredient]
    var category: String
    var time: TimeInfo
    var nutrition: [String: Nutrition]
    
    struct TimeInfo: Codable {
        var single: String
        var couple: String
        var family: String
        
        enum CodingKeys: String, CodingKey {
            case single = "Single"
            case couple = "Couple"
            case family = "Family"
        }
    }
}
