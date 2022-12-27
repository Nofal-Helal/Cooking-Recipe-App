//
//  RecipeDetailViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 27/12/2022.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    required init?(coder: NSCoder, recipe: Recipe) {
        super.init(coder: coder)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
