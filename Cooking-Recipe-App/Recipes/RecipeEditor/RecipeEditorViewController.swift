//
//  RecipeEditorViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class RecipeEditorViewController: UIViewController {
    @IBOutlet var overview: UIView!
    @IBOutlet var ingredients: UIView!
    @IBOutlet var directions: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overview.isHidden = false
        ingredients.isHidden = true
        directions.isHidden = true
        
    }
        

    @IBAction func tabSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            overview.isHidden = false
            ingredients.isHidden = true
            directions.isHidden = true
        case 1:
            overview.isHidden = true
            ingredients.isHidden = false
            directions.isHidden = true
        case 2:
            overview.isHidden = true
            ingredients.isHidden = true
            directions.isHidden = false
        default:
            ()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
