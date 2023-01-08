//
//  DirectionViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 03/01/2023.
//

import UIKit

class DirectionViewController: UIViewController {
    var recipe: Recipe!
    
    @IBOutlet var directs: UITextView!
    
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
        directs.text = recipe.directions.joined(separator: "\n")
        
    }
        
    
    
}
