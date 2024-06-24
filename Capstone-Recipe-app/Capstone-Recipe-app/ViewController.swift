import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var servingSizeFilter: String = "Single"
    var categoryFilter: String?

    let searchController = UISearchController(searchResultsController: nil)
    var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes found."
        label.textAlignment = .center
        label.isHidden = true
        label.frame = CGRect.zero
        return label
    }()
    
    var isSegueInProgress = false 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipe-app"
        setupTableView()
        setupSearchController()
        loadRecipes()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetail",
           let destinationVC = segue.destination as? RecipeDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.recipe = filteredRecipes[indexPath.row]
            destinationVC.selectedFilter = servingSizeFilter  // Pass the selected serving size
        }
        isSegueInProgress = false // Reset the flag after preparing for segue
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
            self?.applyFilters()
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

    private func applyFilters() {
        filteredRecipes = recipes
        if let categoryFilter = categoryFilter {
            filteredRecipes = filteredRecipes.filter { $0.category == categoryFilter }
        }
        filteredRecipes = filteredRecipes.filter { recipe in
            // Here you could add additional filters if necessary
            true
        }
        updateNoResultsLabel()
        tableView.reloadData()
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
        cell.servingSizeFilter = servingSizeFilter
        cell.servingSizeLabel.text = "\(servingSizeFilter)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSegueInProgress {
            isSegueInProgress = true
            performSegue(withIdentifier: "ShowRecipeDetail", sender: self)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noResultsLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        noResultsLabel.center = CGPoint(x: tableView.center.x, y: tableView.bounds.height / 2)
    }

    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        showFilterOptions()
    }

    private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filter Recipes", message: nil, preferredStyle: .actionSheet)

        let singleAction = UIAlertAction(title: "Single", style: .default) { _ in
            self.filterRecipesByServingSize("Single")
        }
        alertController.addAction(singleAction)

        let coupleAction = UIAlertAction(title: "Couple", style: .default) { _ in
            self.filterRecipesByServingSize("Couple")
        }
        alertController.addAction(coupleAction)

        let familyAction = UIAlertAction(title: "Family", style: .default) { _ in
            self.filterRecipesByServingSize("Family")
        }
        alertController.addAction(familyAction)

        let categories = ["Veg.", "Non-Veg."]

        for category in categories {
            let categoryAction = UIAlertAction(title: category, style: .default) { _ in
                self.filterRecipesByCategory(category)
            }
            alertController.addAction(categoryAction)
        }

        let allCategoriesAction = UIAlertAction(title: "All Categories", style: .default) { _ in
            self.categoryFilter = nil
            self.applyFilters()
        }
        alertController.addAction(allCategoriesAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(alertController, animated: true, completion: nil)
    }

    private func filterRecipesByServingSize(_ servingSize: String) {
        servingSizeFilter = servingSize
        applyFilters()
    }

    private func filterRecipesByCategory(_ category: String) {
        categoryFilter = category
        applyFilters()
    }
}
