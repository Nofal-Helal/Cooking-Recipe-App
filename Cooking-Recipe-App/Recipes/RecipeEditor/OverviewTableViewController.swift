//
//  OverviewTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class OverviewTableViewController: UITableViewController {

    @IBOutlet var recipeTitleField: UITextField!
    @IBOutlet var sourceField: UITextField!
    @IBOutlet var yieldField: UITextField!
    @IBOutlet var yieldStepper: UIStepper!
    @IBOutlet var preparationTimePicker: UIDatePicker!
    @IBOutlet var cookingTimePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func stepperPressed(_ sender: UIStepper) {
        yieldField.text = sender.value.formatted(.number)
    }
    
    @IBAction func yieldEdited(_ sender: UITextField) {
        yieldStepper.value = (try? Double(yieldField.text ?? "0", format: .number)) ?? yieldStepper.value
    }
    
    
}
