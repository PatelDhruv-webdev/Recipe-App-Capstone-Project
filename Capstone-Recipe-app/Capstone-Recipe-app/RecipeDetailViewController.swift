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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    var recipe: Recipe? {
        didSet {
            updateUI()
        }
    }

    var selectedFilter: String = "Single"
    var isNutritionInfoVisible = false
    private var timer: Timer?
    private var secondsRemaining: Int = 0
    private var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupInfoButton()
        setupTimer()
        updateUI()
        setupShareButton()
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
    
    private func setupShareButton() {
        shareButton.addTarget(self, action: #selector(shareRecipe), for: .touchUpInside)
    }
    
    @objc private func infoButtonTapped() {
        isNutritionInfoVisible.toggle()
        nutritionLabel.isHidden = !isNutritionInfoVisible
    }

    private func setupTimer() {
        timerLabel.text = "00:00"
        timerButton.setTitle("Start", for: .normal)
    }
    
    @IBAction func timerButtonTapped(_ sender: UIButton) {
        if isTimerRunning {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        guard !isTimerRunning else { return }
        secondsRemaining = calculateEstimatedTime() * 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerButton.setTitle("Reset", for: .normal)
        isTimerRunning = true
    }
        
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
        
    private func resetTimer() {
        stopTimer()
        timerLabel.text = "00:00"
        timerButton.setTitle("Start", for: .normal)
        isTimerRunning = false
    }
        
    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            let minutes = secondsRemaining / 60
            let seconds = secondsRemaining % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            stopTimer()
            timerLabel.text = "Time's up!"
        }
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

    @objc private func shareRecipe() {
        guard let recipe = recipe else { return }

        let recipeText = """
        🌟 Check out this amazing recipe: **\(recipe.title)** 🌟

        📝 **Description:** \(recipe.description)

        ⏰ **Estimated Time:** \(calculateEstimatedTime()) minutes

        🥕 **Ingredients:**
        \(recipe.ingredients.map { "• \($0.name): \($0.quantities[selectedFilter] ?? 0) \($0.unit)" }.joined(separator: "\n"))

        🥗 **Nutrition (\(selectedFilter)):**
        - Calories: \(recipe.nutrition[selectedFilter]?.calories ?? 0) kcal
        - Protein: \(recipe.nutrition[selectedFilter]?.protein ?? 0) g
        - Fat: \(recipe.nutrition[selectedFilter]?.fat ?? 0) g
        - Carbs: \(recipe.nutrition[selectedFilter]?.carbs ?? 0) g

        Download our app for more delicious recipes! 🍽️
        """
        
        // Make sure the image exists
        guard let recipeImage = UIImage(named: recipe.imageName) else {
            presentAlert("Image not found")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [recipeText, recipeImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    private func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
