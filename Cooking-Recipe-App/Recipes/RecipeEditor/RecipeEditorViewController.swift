//
//  RecipeEditorViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class RecipeEditorViewController: UIViewController {
    @IBOutlet var overview: UIView!
    @IBOutlet var ingredients: UIView!
    @IBOutlet var directions: UIView!
    
    var overviewController: OverviewTableViewController!
    var ingredientsController: RecipeTextEditingViewController!
    var directionsController: RecipeTextEditingViewController!
    
    var recipe: Recipe?
    
    required init?(coder: NSCoder, recipe: Recipe) {
        super.init(coder: coder)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overview.isHidden = false
        ingredients.isHidden = true
        directions.isHidden = true
        
        if recipe != nil {
            setup(forRecipe: recipe!)
        }
    }
        

    @IBAction func tabSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            overview.isHidden = false
            ingredients.isHidden = true
            directions.isHidden = true
        case 1:
            overview.isHidden = true
            ingredients.isHidden = false
            directions.isHidden = true
        case 2:
            overview.isHidden = true
            ingredients.isHidden = true
            directions.isHidden = false
        default:
            ()
        }
    }
    
    
    @IBSegueAction func embedOverview(_ coder: NSCoder) -> OverviewTableViewController? {
        let overviewController = OverviewTableViewController(coder: coder)
        self.overviewController = overviewController
        return overviewController
    }
    
    @IBSegueAction func embedIngredients(_ coder: NSCoder) -> RecipeTextEditingViewController? {
        let ingredientsController = RecipeTextEditingViewController(coder: coder)
        self.ingredientsController = ingredientsController
        return ingredientsController
    }
    
    @IBSegueAction func embedDirections(_ coder: NSCoder) -> RecipeTextEditingViewController? {
        let directionsController = RecipeTextEditingViewController(coder: coder)
        self.directionsController = directionsController
        return directionsController
    }
    
    // setup the input fields from recipe data
    func setup(forRecipe recipe: Recipe) {
        self.navigationItem.title = "Edit Recipe"
        // Overview
        overviewController.recipeTitleField.text = recipe.title
        overviewController.categoriesLabel.text = recipe.categories.joined(separator: ", ")
        overviewController.categories = recipe.categories
        overviewController.sourceField.text = recipe.source
        overviewController.yieldField.text = recipe.yield
        overviewController.yieldEdited(overviewController.yieldField)
        overviewController.preparationTimePicker.date.addTimeInterval(recipe.preparationTime)
        overviewController.cookingTimePicker.date.addTimeInterval(recipe.cookingTime)
        overviewController.descriptionTextView.text = recipe.description
        if let image = recipe.image {
            overviewController.recipeImageView.image = UIImage(data: image)
        }
        // Ingredients
        ingredientsController.textView.text = recipe.ingredients.reduce("") { acc, ingredient in
            print("]]]]]]]]]]]]]]]]]]]]]]]]]]]  ",ingredient)
            var str = ""
            if let measurement = ingredient.measurement {
                str.append(measurement.value.formatted(.number))
                str.append(" ")
                str.append(measurement.unit.symbol)
                if !measurement.unit.symbol.isEmpty {
                    str.append(" ")
                }
            }
            str.append(ingredient.text)
            str.append("\n")
            return acc + str
        }
        // Directions
        directionsController.textView.text = recipe.directions.joined(separator: "\n")
    }
    
}
