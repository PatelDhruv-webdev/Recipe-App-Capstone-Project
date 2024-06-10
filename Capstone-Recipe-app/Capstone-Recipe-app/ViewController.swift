import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var recipes = [Recipe]()
    
    var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes found."
        label.textAlignment = .center
        label.isHidden = true
        label.frame = CGRect.zero
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipe-app"
        setupTableView()
        loadRecipes()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.addSubview(noResultsLabel)
    }

    private func loadRecipes() {
        RecipeService.shared.loadRecipes { [weak self] loadedRecipes in
            self?.recipes = loadedRecipes
            self?.tableView.reloadData()
        }
    }

    private func updateNoResultsLabel() {
        noResultsLabel.isHidden = !recipes.isEmpty
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.recipe = recipes[indexPath.row]
        return cell
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noResultsLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        noResultsLabel.center = CGPoint(x: tableView.center.x, y: tableView.bounds.height / 2)
    }
}
