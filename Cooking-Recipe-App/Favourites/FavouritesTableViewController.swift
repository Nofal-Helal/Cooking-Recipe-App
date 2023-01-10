//
//  FavouritesTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 08/01/2023.
//

import UIKit

class FavouritesTableViewController: RecipesTableViewController {

    var favouriteRecipes = [Recipe]()
    
    override func viewDidLoad() {
        searchBarInit()
        
        addButtonInit()
        
        navigationItem.title = "Favourites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipes = Recipe.loadRecipes()!
        
        favouriteRecipes = recipes.filter { $0.isFavourite }
        
        sortRecipes()
    }

    // override recipe source for the table view to favourites
    override var customRecipesSource: [Recipe] {
        get { favouriteRecipes }
        set { favouriteRecipes = newValue }
    }
    
    override func favouriteRecipeAt(indexPath: IndexPath, recipeID: UUID) {
        let index = recipes.firstIndex {$0.id == recipeID}!
        
        // recipes in this view are all favourited, we need only to handle unfavouriting
        assert(recipes[index].isFavourite)
        
        recipes[index].isFavourite = false
        
        Recipe.saveRecipes(recipes)
        
        // remove from both tableview source
        if let favouritesIndex = favouriteRecipes.firstIndex(where: {$0.id == recipeID}) {
            favouriteRecipes.remove(at: favouritesIndex)
        }
        
        if let filteredIndex = filteredRecipes.firstIndex(where: {$0.id == recipeID}) {
            filteredRecipes.remove(at: filteredIndex)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    override func customArrayAppend(recipe: Recipe) {
        if recipe.isFavourite {
            favouriteRecipes.append(recipe)
        }
    }
    
    override func customArrayUpdate(recipe: Recipe) {
        if let index = recipesSource.firstIndex(where: {$0.id == recipe.id}) {
            if recipe.isFavourite {
                recipesSource[index] = recipe
            } else {
                recipesSource.remove(at: index)
            }
        }
    }
    
    override func customTableViewUpdate(recipe: Recipe, at indexPath: IndexPath) {
        if !recipe.isFavourite {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func customTableViewInsert(recipe: Recipe, at indexPath: IndexPath) {
        if recipe.isFavourite {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
}
