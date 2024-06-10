import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }

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
        recipeImageView.image = UIImage(named: recipe.imageName)  // Load image from the Asset Catalog
    }
}
