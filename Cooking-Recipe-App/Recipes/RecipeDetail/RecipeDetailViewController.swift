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
    @IBOutlet var dImage: UIImageView!
    
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
        var p = [NSAttributedString]()
        p.append(contentsOf: recipe.categories.map(Tags.normalTag(_:)))
        p.append(Tags.sourceTag(recipe.source))
        categories.withTags(p)
        
        let (h, m) = Int(recipe.preparationTime).quotientAndRemainder(dividingBy: 3600)
        let hString = h == 0 ? "00h" : " \(h)h"
        let mString = m/60 == 0 && h != 0 ? "" : " \(m/60)m"
        prepTime.text = "\(hString) : \(mString)"
        
        let (hour, minute) = Int(recipe.cookingTime).quotientAndRemainder(dividingBy: 3600)
        let hourString = hour == 0 ? "00h" : " \(hour)h"
        let minuteString = minute/60 == 0 && hour != 0 ? "" : " \(minute/60)m"
        cookTime.text = "\(hourString) : \(minuteString)"
        
        yield.text = String(recipe.yield)
        if let image = recipe.image {
            dImage.image = UIImage(data: image)
        }
        
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
    
    @IBSegueAction func StartDirects(_ coder: NSCoder) -> DirectionViewController? {
        return DirectionViewController(coder: coder, recipe: recipe)
    }
}
