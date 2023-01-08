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

    override var recipesSource: [Recipe] {
        if searchController.isActive {
            return filteredRecipes
        } else {
            return favouriteRecipes
        }
    }
    
    override func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filteredRecipes = favouriteRecipes.filter { recipe in
            recipe.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    override func sortRecipes() {
        if searchController.isActive {
            filteredRecipes.sort(by: self.sortPredicate)
        } else {
            favouriteRecipes.sort(by: self.sortPredicate)
        }
        
        if sortDirection { // descending
            if searchController.isActive {
                filteredRecipes.reverse()
            } else {
                favouriteRecipes.reverse()
            }
        }
        
        tableView.reloadData()
    }
    
    override func favouriteRecipeAt(indexPath: IndexPath, recipeID: UUID) {
        // recipes in this view are all favourited, we need only to handle unfavouriting
        recipes[recipes.firstIndex {$0.id == recipeID}!].isFavourite = false
        Recipe.saveRecipes(recipes)
        favouriteRecipes.remove(at: favouriteRecipes.firstIndex { $0.id == recipeID }!)
        
        if searchController.isActive {
            // remove recipe from search results collection
            filteredRecipes.remove(at: filteredRecipes.firstIndex { $0.id == recipeID }!)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}
