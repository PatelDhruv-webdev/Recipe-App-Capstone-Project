import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!

    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }
    var selectedFilter: String = "Single"

    override func viewDidLoad() {
        super.viewDidLoad()
        debugOutlets()
        setupTableView()
        updateUI()
    }

    private func setupTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
    }

    private func updateUI() {
        guard isViewLoaded else { return }
        guard let recipe = recipe else { return }
        titleLabel.text = recipe.title
        descriptionLabel.text = recipe.description
        if let imageName = recipe.imageName {
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultRecipeImage")
        } else {
            imageView.image = UIImage(named: "defaultRecipeImage")
        }
        ingredientsTableView.reloadData()
    }

    private func debugOutlets() {
        if imageView == nil {
            print("imageView is nil")
        }
        if titleLabel == nil {
            print("titleLabel is nil")
        }
        if descriptionLabel == nil {
            print("descriptionLabel is nil")
        }
        if ingredientsTableView == nil {
            print("ingredientsTableView is nil")
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent || self.isBeingDismissed {
            if let parentVC = self.navigationController?.viewControllers.first as? ViewController {
                parentVC.isSegueInProgress = false // Reset the flag when coming back
            }
        }
    }
}
