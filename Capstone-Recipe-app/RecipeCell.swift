import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    
    
    
    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }

    var servingSizeFilter: String = "Single" // Default serving size filter
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
    }

    private func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }

    private func updateUI() {
        guard let recipe = recipe else { return }
        
        titleLabel.text = recipe.title
        descriptionLabel.text = recipe.description     
        
        if let imageName = recipe.imageName, let image = UIImage(named: imageName) {
            recipeImageView.image = image
        } else {
            recipeImageView.image = UIImage(named: "defaultRecipeImage")
        }

        // Update servingSizeLabel based on servingSizeFilter
        servingSizeLabel.text = "\(servingSizeFilter)"
    }

    private func calculateEstimatedTime(recipe: Recipe) -> Int {
        // Logic to calculate estimated time based on serving size filter
        switch servingSizeFilter {
        case "Single":
            return recipe.time.singleInMinutes()
        case "Couple":
            return recipe.time.coupleInMinutes()
        case "Family":
            return recipe.time.familyInMinutes()
        default:
            return recipe.time.singleInMinutes() // Default to single serving
        }
    }
}

extension Recipe.TimeInfo {
    func singleInMinutes() -> Int {
        return Int(single.components(separatedBy: " ")[0]) ?? 0
    }
    
    func coupleInMinutes() -> Int {
        return Int(couple.components(separatedBy: " ")[0]) ?? 0
    }
    
    func familyInMinutes() -> Int {
        return Int(family.components(separatedBy: " ")[0]) ?? 0
    }
}

