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
        recipeImageView.image = UIImage(named: recipe.imageName)
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
