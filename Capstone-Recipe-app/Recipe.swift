import Foundation

struct Recipe: Codable {
    var title: String
    var description: String
    var imageName: String
    var ingredients: [Ingredient]
    var category: String
    var time: TimeInfo
    
    struct TimeInfo: Codable {
        var single: String
        var couple: String
        var family: String
        
        enum CodingKeys: String, Swift.CodingKey {
            case single = "Single"
            case couple = "Couple"
            case family = "Family"
        }
    }
}

struct Ingredient: Codable {
    var name: String
    var quantities: [String: Double]
    var unit: String
}
