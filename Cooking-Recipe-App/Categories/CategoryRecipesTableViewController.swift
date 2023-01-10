//
//  CategoryRecipesTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by mobileProg on 10/01/2023.
//

import UIKit

class CategoryRecipesTableViewController: RecipesTableViewController {

    var category: String!
    var categoryRecipes = [Recipe]()
    
    required init?(coder: NSCoder, category: String) {
        super.init(coder: coder)
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        searchBarInit()
        
        addButtonInit()
        
        navigationItem.title = category
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipes = Recipe.loadRecipes()!
        
        categoryRecipes = recipes.filter { $0.categories.contains(category) }
        
        sortRecipes()
    }

    // MARK: - Table view data source

    override var customRecipesSource: [Recipe] {
        get { categoryRecipes }
        set { categoryRecipes = newValue }
    }
    
    override func customArrayAppend(recipe: Recipe) {
        if recipe.categories.contains(category) {
            recipesSource.append(recipe)
        }
    }
    
    override func customArrayUpdate(recipe: Recipe) {
        if let index = recipesSource.firstIndex(where: {$0.categories.contains(category)}) {
            if recipe.isFavourite {
                recipesSource[index] = recipe
            } else {
                recipesSource.remove(at: index)
            }
        }
    }
    
    override func customTableViewInsert(recipe: Recipe, at indexPath: IndexPath) {
        if recipe.categories.contains(category) {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    override func customTableViewUpdate(recipe: Recipe, at indexPath: IndexPath) {
        if !recipe.categories.contains(category) {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }

    }
}
