//  RecipeOfTheDayViewController.swift
//  Capstone-Recipe-app
//  Created by Tirth Shah on 2024-07-21.

import UIKit

class RecipeOfTheDayViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipes()
    }
    
    private func loadRecipes() {
        RecipeService.shared.loadRecipes { [weak self] loadedRecipes in
            self?.recipes = loadedRecipes
            self?.setRecipeOfTheDay()
        }
    }
    
    private func setRecipeOfTheDay() {
        guard !recipes.isEmpty else { return }
        if let randomRecipe = recipes.randomElement() {
            updateUI(with: randomRecipe)
        }
    }
    
    private func updateUI(with recipe: Recipe) {
        titleLabel.text = recipe.title
        descriptionLabel.text = recipe.description
        imageView.image = UIImage(named: recipe.imageName)
    }
}
