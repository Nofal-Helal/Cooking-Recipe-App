//
//  RecipeDetailViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 27/12/2022.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe!
    var ingreds : [Ingredient]!
    @IBOutlet var dTitle: UILabel!
    @IBOutlet var dDesc: UILabel!
    @IBOutlet var categories: Tags!
    @IBOutlet var dImage: UIImageView!
    
    @IBOutlet var prepTime: UILabel!
    @IBOutlet var cookTime: UILabel!
    @IBOutlet var yield: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadStuff()
        registerTableCells()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerTableCells(){
        tableView.register(UINib(nibName: "IngredsTitle", bundle: nil), forCellReuseIdentifier: "IngredsTitle")
    }
    
    required init?(coder: NSCoder, recipe: Recipe) {
        super.init(coder: coder)
        self.recipe = recipe
        self.ingreds = recipe.ingredients
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
        let mString = m/60 == 0 && h != 0 ? "00m" : " \(m/60)m"
        prepTime.text = "\(hString) : \(mString)"
        
        let (hour, minute) = Int(recipe.cookingTime).quotientAndRemainder(dividingBy: 3600)
        let hourString = hour == 0 ? "00h" : " \(hour)h"
        let minuteString = minute/60 == 0 && hour != 0 ? "00m" : " \(minute/60)m"
        cookTime.text = "\(hourString) : \(minuteString)"
        
        yield.text = String(recipe.yield)
        if let image = recipe.image {
            dImage.image = UIImage(data: image)
        }
        
    }
    @IBSegueAction func StartDirects(_ coder: NSCoder) -> DirectionViewController? {
        return DirectionViewController(coder: coder, recipe: recipe)
    }
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource{
    //how many headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ingreds.count
    }
    
    //prints rows and change design
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredsTitle") as! IngredsTitle
        cell.title.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.tag = indexPath.row
        switch indexPath.section {
        case 0:
            cell.title.text = "\(ingreds[indexPath.row])"
        default:
            return UITableViewCell()
        }

        return cell
    }
    //prints header and change design
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredsTitle") as! IngredsTitle
        cell.title.font = UIFont.boldSystemFont(ofSize: 1)
        cell.title.text = ""
        return cell
    }
    //design stuff
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 30
        default:
            return 30
        }
    }
    //this too
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 0
        }
    }
    //also this
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return 20
        }
    }
}
