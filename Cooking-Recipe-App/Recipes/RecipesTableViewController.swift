//
//  RecipesTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 14/12/2022.
//

import UIKit

class RecipesTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var recipes: [Recipe] = Recipe.sample_recipes //[Recipe].init(repeating: Recipe.sample_recipes[0], count: 10)
    var filteredRecipes: [Recipe] = [Recipe]()

    let searchController = UISearchController()
    let addButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup searchbar
        searchBarInit()
        
        // floating add button
        addButtonInit()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Search Results
    
    private func searchBarInit() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filteredRecipes = recipes.filter { recipe in
            recipe.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredRecipes.count
        }
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        // Configure the cell...
        let recipe: Recipe!
        if searchController.isActive {
            recipe = filteredRecipes[indexPath.row]
        } else {
            recipe = recipes[indexPath.row]
        }
        
        cell.configure(forRecipe: recipe)
        
        return cell
    }
    
    @IBAction func recipeLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let indexPath = tableView.indexPathForRow(at: gestureRecognizer.location(in: tableView))
        if indexPath != nil && gestureRecognizer.state == .began {
            let recipeTitle = recipes[indexPath!.row].title
            
            let alertController = UIAlertController(title: "Recipe Action", message: recipeTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Favourite Recipe", style: .default) { _ in })
            alertController.addAction(UIAlertAction(title: "Edit Recipe", style: .default) { _ in })
            alertController.addAction(UIAlertAction(title: "Delete Recipe", style: .destructive) { _ in })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
        }
    }
    
    private func addButtonInit() {
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
        let recipe = recipes[indexPath.row]
        return RecipeDetailViewController(coder: coder, recipe: recipe)
    }
}
