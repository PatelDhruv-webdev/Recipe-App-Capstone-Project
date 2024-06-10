import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!

    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()

    let searchController = UISearchController(searchResultsController: nil)
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
        self.title = "Recippe-app"
        setupTableView()
        setupSearchController()
        loadRecipes()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.addSubview(noResultsLabel)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func loadRecipes() {
        RecipeService.shared.loadRecipes { [weak self] loadedRecipes in
            self?.recipes = loadedRecipes
            self?.filteredRecipes = loadedRecipes
            self?.tableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredRecipes = recipes
            updateNoResultsLabel()
            return
        }

        filteredRecipes = recipes.filter { recipe in
            recipe.title.lowercased().contains(searchText.lowercased())
        }

        updateNoResultsLabel()
    }

    private func updateNoResultsLabel() {
        noResultsLabel.isHidden = !filteredRecipes.isEmpty
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.recipe = filteredRecipes[indexPath.row]
        return cell
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noResultsLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        noResultsLabel.center = CGPoint(x: tableView.center.x, y: tableView.bounds.height / 2)
    }
}

