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
    
    @IBOutlet var favouriteButton: UIBarButtonItem!
    
    var recipe: Recipe?
    var recipeID: UUID? // id of recipe being edited
    var isFavourite: Bool = false
    
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
        
        if isFavourite {
            favouriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favouriteButton.image = UIImage(systemName: "heart")
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
        self.recipeID = recipe.id
        self.navigationItem.title = "Edit Recipe"
        self.isFavourite = recipe.isFavourite
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
            overviewController.imageData = image
        }
        // Ingredients
        ingredientsController.textView.text = recipe.ingredients.reduce("") { acc, ingredient in
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
            return (acc ?? "") + str
        }
        // Directions
        directionsController.textView.text = recipe.directions.joined(separator: "\n")
    }
    
    func getRecipe() -> Recipe {
        let id = recipeID ?? UUID()
        let title: String = {
            let text = overviewController.recipeTitleField.text
            if text == nil || text!.isEmpty {
                return "Untitled Recipe"
            } else {
                return text!
            }
        }()
        let image = overviewController.imageData ?? UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.9)
        let categories = overviewController.categories
        let source: String = {
            let text = overviewController.sourceField.text;
            if text == nil || text!.isEmpty {
                return "You"
            } else {
                return text!
            }
        }()
        let yield = overviewController.yieldField.text!
        let preparationTime: TimeInterval = {
            let components = Calendar.current.dateComponents([.hour, .minute],
                                                             from: overviewController.preparationTimePicker.date)
            return TimeInterval(components.hour! * 3600 + components.minute! * 60)
        }()
        let cookingTime: TimeInterval = {
            let components = Calendar.current.dateComponents([.hour, .minute],
                                                             from: overviewController.cookingTimePicker.date)
            return TimeInterval(components.hour! * 3600 + components.minute! * 60)
        }()
        let description = overviewController.descriptionTextView.text
        
        let ingredients = ingredientsController.textView.text!.components(separatedBy: "\n").map {
            line in
            return Ingredient(fromLine: line) ?? Ingredient(text: line)
        }
        
        let directions = directionsController.textView.text!.components(separatedBy: "\n")
        
        return Recipe(id: id,
                      title: title,
                      categories: categories,
                      source: source,
                      yield: yield,
                      preparationTime: preparationTime,
                      cookingTime: cookingTime,
                      description: description,
                      image: image,
                      ingredients: ingredients,
                      directions: directions,
                      isFavourite: isFavourite)
        
    }
    
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        isFavourite.toggle()
        if isFavourite {
            favouriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favouriteButton.image = UIImage(systemName: "heart")
        }
    }
    
}
