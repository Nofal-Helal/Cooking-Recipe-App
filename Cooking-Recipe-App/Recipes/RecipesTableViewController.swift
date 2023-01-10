//
//  RecipesTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 14/12/2022.
//

import UIKit

class RecipesTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var recipes: [Recipe]!
    var filteredRecipes: [Recipe] = [Recipe]()
    var sortPredicate: (Recipe, Recipe) -> Bool = { $0.title.caseInsensitiveCompare($1.title) == .orderedAscending }
    var sortDirection: Bool = false // false for ascending, true for descending

    let searchController = UISearchController()
    let addButton = UIButton()
    
    var editingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup searchbar
        searchBarInit()
        
        // floating add button
        addButtonInit()

        // set display theme
        SettingsViewController.setDisplayTheme(DisplayTheme(rawValue: UserDefaults.standard.integer(forKey: "Display Theme")) ?? .System)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recipes = Recipe.loadRecipes()!
        
        sortRecipes()
    }
    
    // MARK: - Search Results
    
    func searchBarInit() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .bookmark, state: .normal)
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filteredRecipes = customRecipesSource.filter { recipe in
            recipe.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let alertController = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Recipe Title (A-Z)", style: .default) { _ in
            self.sortPredicate = { $0.title.caseInsensitiveCompare($1.title) == .orderedAscending }
            self.sortRecipes()
        })
        alertController.addAction(UIAlertAction(title: "Cooking Time", style: .default) { _ in
            self.sortPredicate = { ($0.preparationTime+$0.cookingTime) < ($1.preparationTime+$1.cookingTime) }
            self.sortRecipes()
        })
        alertController.addAction(UIAlertAction(title: "Number of Ingredients", style: .default) { _ in
            self.sortPredicate = {$0.ingredients.count < $1.ingredients.count }
            self.sortRecipes()
        })
        alertController.addAction(UIAlertAction(title: "Sort Ascending", style: .default) { _ in
            self.sortDirection = false
            self.sortRecipes()
        })
        alertController.addAction(UIAlertAction(title: "Sort Descending", style: .default) { _ in
            self.sortDirection = true
            self.sortRecipes()
        })
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    func sortRecipes() {
        recipesSource.sort(by: self.sortPredicate)
        
        if sortDirection { // descending
            recipesSource.reverse()
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    /// override this to set the recipe source
    var customRecipesSource: [Recipe] {
        get { recipes }
        set { recipes = newValue}
    }
    
    /// recipes source for the tableview depending on the state of the search controller
    var recipesSource: [Recipe] {
        get {
            if searchController.isActive {
                return filteredRecipes
            } else {
                return customRecipesSource
            }
        }
        
        set {
            if searchController.isActive {
                filteredRecipes = newValue
            } else {
                customRecipesSource = newValue
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        // Configure the cell...
        let recipe = recipesSource[indexPath.row]
        cell.configure(forRecipe: recipe)
        
        return cell
    }
    
    @IBAction func recipeLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let indexPath = tableView.indexPathForRow(at: gestureRecognizer.location(in: tableView))
        if indexPath != nil && gestureRecognizer.state == .began {
            let indexPath = indexPath!
            let recipeTitle = recipesSource[indexPath.row].title
            let recipeID = recipesSource[indexPath.row].id
            let isFavourite = recipesSource[indexPath.row].isFavourite
            let favTitle = isFavourite ? "Unfavourite Recipe" : "Favourite Recipe"
            editingIndexPath = indexPath
            
            let alertController = UIAlertController(title: "Recipe Action", message: recipeTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: favTitle, style: .default) { [self, indexPath, recipeID] _ in
                favouriteRecipeAt(indexPath: indexPath, recipeID: recipeID)
            })
            alertController.addAction(UIAlertAction(title: "Edit Recipe", style: .default) { [self, indexPath] _ in
                performSegue(withIdentifier: "Edit Recipe", sender: tableView.cellForRow(at: indexPath) )
            })
            alertController.addAction(UIAlertAction(title: "Delete Recipe", style: .destructive) { _ in
                let confirmationAlert = UIAlertController(title: "Delete Recipe",
                                                          message: "Are you sure you want to delete the recipe \"\(recipeTitle)\"?", preferredStyle: .alert)
                confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [self, indexPath, recipeID] _ in
                    deleteRecipeAt(indexPath: indexPath, recipeID: recipeID)
                })
                confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(confirmationAlert, animated: true)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
        }
    }
    
    func addButtonInit() {
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 25
        addButton.layer.masksToBounds = false
        addButton.layer.shadowRadius = 10
        addButton.layer.shadowOpacity = 0.3
        tableView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Add Recipe", sender: nil)
    }
    
     @IBSegueAction func editRecipe(_ coder: NSCoder, sender: RecipeTableViewCell?) -> RecipeEditorViewController? {
         guard let sender = sender,
               let indexPath = tableView.indexPath(for: sender)
         else {
             return nil
         }
         let recipe = recipesSource[indexPath.row]
         return RecipeEditorViewController(coder: coder, recipe: recipe)
     }
    
    
    func deleteRecipeAt(indexPath: IndexPath, recipeID: UUID) {
        // remove recipe from the main recipes collection
        recipes.remove(at: recipes.firstIndex { $0.id == recipeID }!)
        
        // remove from table view source array
        if let index = recipesSource.firstIndex(where: {$0.id == recipeID}) {
            recipesSource.remove(at: index)
        }
        
        // delete row from table view
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        Recipe.saveRecipes(recipes)
    }
    
    func favouriteRecipeAt(indexPath: IndexPath, recipeID: UUID) {
        let isFavourite = recipes[recipes.firstIndex {$0.id == recipeID}!].isFavourite
        
        recipes[recipes.firstIndex {$0.id == recipeID}!].isFavourite.toggle()
        
        recipesSource[recipesSource.firstIndex {$0.id == recipeID}!].isFavourite = !isFavourite
        
        Recipe.saveRecipes(recipes)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBSegueAction func viewRecipeDetails(_ coder: NSCoder, sender: RecipeTableViewCell!) -> UIViewController? {
        guard let indexPath = tableView.indexPath(for: sender) else {return nil}
        let recipe = recipesSource[indexPath.row]
        return RecipeDetailViewController(coder: coder, recipe: recipe)
    }
    
    @IBAction func unwindFromSaveRecipe(segue: UIStoryboardSegue) {
        assert(segue.identifier == "Unwind Save")
        let recipeEditor = segue.source as! RecipeEditorViewController
        let recipe = recipeEditor.getRecipe()
        
        if let selectedIndexPath = self.editingIndexPath,
           let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            // update the main recipes collection for saving
            recipes[index] = recipe
            
            // update the tableview source array
            customArrayUpdate(recipe: recipe)
            
            // update the tableview
            customTableViewUpdate(recipe: recipe, at: selectedIndexPath)
            
        } else {
            assert(recipes.firstIndex { $0.id == recipe.id } == nil)
            let newIndexPath = IndexPath(row: recipesSource.count, section: 0)
            
            // append to main recipes collection
            recipes.append(recipe)
            
            // append to table view source array
            customArrayAppend(recipe: recipe)
            
            if searchController.isActive {
                // update search results to automatically add it to filtered recipes array
                updateSearchResults(for: searchController)
                tableView.reloadRows(at: [newIndexPath], with: .automatic)
            } else {
                customTableViewInsert(recipe: recipe, at: newIndexPath)
            }
        }
        
        Recipe.saveRecipes(recipes)
        editingIndexPath = nil
    }
    
    
    
    /// Append recipe to the subclass
    func customArrayAppend(recipe: Recipe) {}
    
    func customArrayUpdate(recipe: Recipe) {
        if let index = recipesSource.firstIndex(where: {$0.id == recipe.id}) {
            recipesSource[index] = recipe
        }
    }
    
    func customTableViewUpdate(recipe: Recipe, at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func customTableViewInsert(recipe: Recipe, at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
