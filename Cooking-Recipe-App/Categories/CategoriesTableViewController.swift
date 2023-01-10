//
//  CategoriesTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 14/12/2022.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    var categories: [Category]!
    
    var editingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = Category.loadCategories() ?? Category.sampleCategories
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
   
    @IBAction func save(_ sender: Any) {
        tableView.isEditing = true
    }
    
  
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoriesTableViewCell
        let category = categories[indexPath.row]
        let numberRecipes = Recipe.loadRecipes()?.filter({ $0.categories.contains(category.title) }).count ?? 0
        if let imageData = category.imageData {
            cell.iconImageView.image = UIImage(data: imageData)
        } else {
            cell.iconImageView.image = UIImage(named: "placeholder")
        }
        cell.label1.text = "\(numberRecipes) Recipes"
        cell.label.text = category.title
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140

    }

    @IBSegueAction func viewRecipesInCategory(_ coder: NSCoder, sender: UITableViewCell?) -> CategoryRecipesTableViewController? {
        let indexPath = tableView.indexPath(for: sender!)!
        let category = categories[indexPath.row].title
        return CategoryRecipesTableViewController(coder: coder, category: category)
    }
    
    @IBSegueAction func editCategory(_ coder: NSCoder, sender: UITableViewCell?) -> CategoryAddEditViewController? {
        let indexPath = tableView.indexPath(for: sender!)!
        let category = categories[indexPath.row]
        editingIndexPath = indexPath
        return CategoryAddEditViewController(coder: coder, category: category)
    }
    
    @IBAction func categoryLongPressed(_ sender: UILongPressGestureRecognizer) {
        let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView))
        if indexPath != nil && sender.state == .began {
            let indexPath = indexPath!
            let categoryTitle = categories[indexPath.row].title
            
            let alertController = UIAlertController(title: "Category Action", message: categoryTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Edit Category", style: .default) {
                [self, indexPath] _ in
                performSegue(withIdentifier: "EditCategory", sender: tableView.cellForRow(at: indexPath) )
            })
            alertController.addAction(UIAlertAction(title: "Delete Category", style: .destructive) { [self] _ in
                deleteCategoryAt(indexPath)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
        }

    }
    
    func deleteCategoryAt(_ indexPath: IndexPath) {
        let category = categories[indexPath.row].title
        let confirmationAlert = UIAlertController(title: "Delete Category",
                                                  message: "Are you sure you want to delete the category \"\(category)\"? This will remove the \"\(category)\" category tag from recipes",
                                                  preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [self, indexPath] _ in
            // delete category
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // remove category from recipes
            var recipes = Recipe.loadRecipes()!.map { recipe -> Recipe in
                var recipe = recipe
                var categories = recipe.categories
                if let index = categories.firstIndex(of: category) {
                    categories.remove(at: index)
                }
                recipe.categories = categories
                return recipe
            }
            
            Recipe.saveRecipes(recipes)
            Category.saveCategories(categories)
        })
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(confirmationAlert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindFromCategorySave(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! CategoryAddEditViewController
        
        let categoryText = sourceViewController.categoryTextField.text!
        let categoryTitle = categoryText.isEmpty ? "Unnamed Category" : categoryText
        let categoryImage = sourceViewController.categoryImageData
        let category = Category(title: categoryTitle, imageData: categoryImage)
        
        if let selectedIndexPath = editingIndexPath {
            categories[selectedIndexPath.row] = category
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: categories.count, section: 0)
            categories.append(category)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Category.saveCategories(categories)
    }
}
