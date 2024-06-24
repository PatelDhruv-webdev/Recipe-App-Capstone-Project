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

    var servingSizeFilter: String = "Single" // Add this property

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
        
        if let imageName = recipe.imageName {
            recipeImageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultRecipeImage")
        } else {
            recipeImageView.image = UIImage(named: "defaultRecipeImage")
        }

        // Update servingSizeLabel based on servingSizeFilter
        if let firstIngredient = recipe.ingredients.first {
            let quantity = firstIngredient.quantities[servingSizeFilter] ?? 0
            servingSizeLabel.text = "First ingredient (\(firstIngredient.name)): \(quantity) \(firstIngredient.unit)"
        }
    }
}

