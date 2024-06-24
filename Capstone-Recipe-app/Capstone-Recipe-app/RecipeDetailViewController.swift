import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    
    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }

    var selectedFilter: String = "Single"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateUI()
    }

    private func setupTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell") // Registering cell if not done in storyboard
    }

    private func updateUI() {
        guard isViewLoaded else { return }
        guard let recipe = recipe else { return }
        
        titleLabel.text = recipe.title
        descriptionLabel.text = recipe.description
        estimatedTimeLabel.text = "Estimated Time: \(calculateEstimatedTime()) minutes"
        
        if let imageName = recipe.imageName {
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultRecipeImage")
        } else {
            imageView.image = UIImage(named: "defaultRecipeImage")
        }
        
        ingredientsTableView.reloadData()
    }

    private func calculateEstimatedTime() -> Int {
        guard let recipe = recipe else { return 0 }
        
        switch selectedFilter {
        case "Single":
            return extractMinutes(from: recipe.time.single)
        case "Couple":
            return extractMinutes(from: recipe.time.couple)
        case "Family":
            return extractMinutes(from: recipe.time.family)
        default:
            return 0
        }
    }
    
    private func extractMinutes(from timeString: String) -> Int {
        let components = timeString.components(separatedBy: " ")
        if let minutes = Int(components[0]) {
            return minutes
        } else {
            return 0
        }
    }

    // Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        if let ingredient = recipe?.ingredients[indexPath.row] {
            let quantity = ingredient.quantities[selectedFilter] ?? 0
            cell.textLabel?.text = "\(ingredient.name): \(quantity) \(ingredient.unit)"
        }
        return cell
    }
}

