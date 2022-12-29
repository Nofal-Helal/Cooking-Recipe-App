//
//  CategoriesSelectorTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 29/12/2022.
//

import UIKit

class CategoriesSelectorTableViewController: UITableViewController {
    
    var selectedCategories: Set<String>

    init?(coder: NSCoder, categories: [String]) {
        selectedCategories = Set<String>(categories)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    // TODO: load categories from storage
    var data: [CategoriesTableViewController.Category]=[
        CategoriesTableViewController.Category(title: "Breakfast",ImageName: UIImage(named: "img_breakfast")!),
        CategoriesTableViewController.Category(title: "Dinner", ImageName: UIImage(named:"img_dinner")!),
        CategoriesTableViewController.Category(title: "Lunch", ImageName: UIImage(named:"img_lunch")!),
        CategoriesTableViewController.Category(title: "Dessert", ImageName: UIImage(named:"img_dessert")!)
        
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let category = data[indexPath.row]
        cell.textLabel?.text = category.title
        if selectedCategories.contains(category.title) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            selectedCategories.insert(data[indexPath.row].title)
        } else {
            cell?.accessoryType = .none
            selectedCategories.remove(data[indexPath.row].title)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
