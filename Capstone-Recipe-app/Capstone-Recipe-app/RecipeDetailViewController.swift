import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var nutritionalInfoTitleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }

    var selectedFilter: String = "Single"
    var isNutritionInfoVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupInfoButton()
        updateUI()
    }
    
    private func setupTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }
    private func setupInfoButton() {
            infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
            nutritionLabel.isHidden = true
        }
        
        @objc private func infoButtonTapped() {
            isNutritionInfoVisible.toggle()
            nutritionLabel.isHidden = !isNutritionInfoVisible
        }

    private func updateUI() {
        guard isViewLoaded else { return }
        guard let recipe = recipe else { return }
        
        recipeTitle.text = recipe.title
        recipeDescription.text = recipe.description
        estimateTime.text = "Estimated Time: \(calculateEstimatedTime()) Minutes"
        imageView.image = UIImage(named: recipe.imageName)
        updateNutritionInfo()
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
    private func updateNutritionInfo() {
        guard let nutrition = recipe?.nutrition[selectedFilter] else { return }
        
        let boldFont = UIFont.boldSystemFont(ofSize: 17)
        let normalFont = UIFont.systemFont(ofSize: 17)
        
        let attributedText = NSMutableAttributedString()
        
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
        
        attributedText.append(NSAttributedString(string: "Calories: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(nutrition.calories) kcal\n", attributes: normalAttributes))
        
        attributedText.append(NSAttributedString(string: "Protein: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(nutrition.protein) g\n", attributes: normalAttributes))
        
        attributedText.append(NSAttributedString(string: "Fat: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(nutrition.fat) g\n", attributes: normalAttributes))
        
        attributedText.append(NSAttributedString(string: "Carbs: ", attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "\(nutrition.carbs) g", attributes: normalAttributes))
        
        nutritionLabel.attributedText = attributedText
    }

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
