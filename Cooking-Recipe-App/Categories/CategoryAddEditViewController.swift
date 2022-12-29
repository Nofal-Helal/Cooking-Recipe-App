//
//  CategoryAddEditViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 29/12/2022.
//

import UIKit

class CategoryAddEditViewController: UIViewController {

    var category: Category?
    
    @IBOutlet weak var category1: UITextField!
    
    required init?(coder: NSCoder, category: Category) {
        super.init(coder: coder)
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            
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
