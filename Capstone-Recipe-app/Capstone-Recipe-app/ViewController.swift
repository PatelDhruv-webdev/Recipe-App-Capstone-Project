import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sortButton: UIBarButtonItem!

    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var servingSizeFilter: String = "Single"
    var categoryFilter: String?
    var searchText: String?
    var selectedTimeSlot: TimeSlot = .all
    var isShowingPopular: Bool = false

    enum TimeSlot {
        case all
        case tenToFifteen
        case fifteenToThirty
        case thirtyAndMore
        
        var description: String {
            switch self {
            case .all:
                return "All"
            case .tenToFifteen:
                return "10-15 mins"
            case .fifteenToThirty:
                return "15-30 mins"
            case .thirtyAndMore:
                return "30 mins and more"
            }
        }
        
        func matches(minutes: Int) -> Bool {
            switch self {
            case .all:
                return true
            case .tenToFifteen:
                return (10...15).contains(minutes)
            case .fifteenToThirty:
                return (16...30).contains(minutes)
            case .thirtyAndMore:
                return minutes > 30
            }
        }
    }

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
        setupTableView()
        setupSearchController()
        loadRecipes()
        setupSegmentedControl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetail",
           let destinationVC = segue.destination as? RecipeDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.recipe = filteredRecipes[indexPath.row]
            destinationVC.selectedFilter = servingSizeFilter
        }
        isSegueInProgress = false
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
        }
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text
        applyFilters()
    }
    
    private func applyFilters() {
        if isShowingPopular {
            filteredRecipes = getMostPopularRecipes()
        } else {
            filteredRecipes = recipes
            
            if let categoryFilter = categoryFilter {
                filteredRecipes = filteredRecipes.filter { $0.category == categoryFilter }
            }
            
            filteredRecipes = filteredRecipes.filter { recipe in
                if let searchText = searchText, !searchText.isEmpty {
                    let containsTitle = recipe.title.lowercased().contains(searchText.lowercased())
                    let containsIngredient = recipe.ingredients.contains { $0.name.lowercased().contains(searchText.lowercased()) }
                    return containsTitle || containsIngredient
                }
                return true
            }
            
            filteredRecipes = filteredRecipes.filter { recipe in
                let minutes = extractMinutes(from: recipe.time, for: servingSizeFilter)
                return selectedTimeSlot.matches(minutes: minutes)
            }
            
            filteredRecipes.sort { recipe1, recipe2 in
                return extractMinutes(from: recipe1.time, for: servingSizeFilter) < extractMinutes(from: recipe2.time, for: servingSizeFilter)
            }
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
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            servingSizeFilter = "Single"
        case 1:
            servingSizeFilter = "Couple"
        case 2:
            servingSizeFilter = "Family"
        default:
            servingSizeFilter = "Single"
        }
        applyFilters()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        showFilterOptions()
    }
    
    private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filter Recipes", message: nil, preferredStyle: .actionSheet)
        
        let mostPopularAction = UIAlertAction(title: "Most Popular", style: .default) { _ in
            self.isShowingPopular = true
            self.categoryFilter = nil
            self.applyFilters()
        }
        alertController.addAction(mostPopularAction)

        let categories = ["Veg.", "Non-Veg."]
        
        for category in categories {
            let categoryAction = UIAlertAction(title: category, style: .default) { _ in
                self.isShowingPopular = false
                self.filterRecipesByCategory(category)
            }
            alertController.addAction(categoryAction)
        }
        
        let allCategoriesAction = UIAlertAction(title: "All Categories", style: .default) { _ in
            self.isShowingPopular = false
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
    
    private func getMostPopularRecipes() -> [Recipe] {
        return recipes.filter { recipe in
            recipe.title == "Chocolate Cake" || recipe.title == "Spaghetti Carbonara" || recipe.title == "Margherita Pizza"
        }
    }

    private func filterRecipesByCategory(_ category: String) {
        self.categoryFilter = category
        self.applyFilters()
    }
    
    private func showTimeSlotOptions() {
        let alertController = UIAlertController(title: "Select Time Slot", message: "Choose the preparation time slot for sorting.", preferredStyle: .actionSheet)

        let allAction = UIAlertAction(title: TimeSlot.all.description, style: .default) { _ in
            self.selectedTimeSlot = .all
            self.applyFilters()
        }
        let tenToFifteenAction = UIAlertAction(title: TimeSlot.tenToFifteen.description, style: .default) { _ in
            self.selectedTimeSlot = .tenToFifteen
            self.applyFilters()
        }
        let fifteenToThirtyAction = UIAlertAction(title: TimeSlot.fifteenToThirty.description, style: .default) { _ in
            self.selectedTimeSlot = .fifteenToThirty
            self.applyFilters()
        }
        let thirtyAndMoreAction = UIAlertAction(title: TimeSlot.thirtyAndMore.description, style: .default) { _ in
            self.selectedTimeSlot = .thirtyAndMore
            self.applyFilters()
        }
        alertController.addAction(allAction)
        alertController.addAction(tenToFifteenAction)
        alertController.addAction(fifteenToThirtyAction)
        alertController.addAction(thirtyAndMoreAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        showTimeSlotOptions()
    }
    
    private func filterRecipesByServingSize(_ servingSize: String) {
        servingSizeFilter = servingSize
        applyFilters()
    }
    
    private func extractMinutes(from timeInfo: Recipe.TimeInfo, for timeSlot: String) -> Int {
        switch timeSlot {
        case "Single":
            return extractMinutes(from: timeInfo.single)
        case "Couple":
            return extractMinutes(from: timeInfo.couple)
        case "Family":
            return extractMinutes(from: timeInfo.family)
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
}

