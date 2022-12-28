//
//  RecipeDetailViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 27/12/2022.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe!
    @IBOutlet var dTitle: UILabel!
    @IBOutlet var dDesc: UILabel!
    @IBOutlet var categories: Tags!
    
    @IBOutlet var prepTime: UILabel!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var yield: UILabel!
    @IBOutlet var ingredTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadStuff()
    }
    
    required init?(coder: NSCoder, recipe: Recipe) {
        super.init(coder: coder)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  loadStuff(){
        
        
        dTitle.text = recipe.title
        dDesc.text = recipe.description
        //categories = recipe.categories
        prepTime.text = String(recipe.preparationTime)
        cookTime.text = String(recipe.cookingTime)
        yield.text = String(recipe.yield)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return recipe.ingredients.count
    }
    
   /* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingreds")
        
        cell.ingrs.text = recipe.ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingreds")
        cell.font = UIFont.boldSystemFont(ofSize: 20)
        cell.text = "Ingredients"
        return cell
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 10
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 10
        }
    }
    
}
