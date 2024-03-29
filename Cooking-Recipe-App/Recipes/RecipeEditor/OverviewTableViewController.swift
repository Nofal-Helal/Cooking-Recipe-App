//
//  OverviewTableViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class OverviewTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var recipeTitleField: UITextField!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var sourceField: UITextField!
    @IBOutlet var yieldField: UITextField!
    @IBOutlet var yieldStepper: UIStepper!
    @IBOutlet var preparationTimePicker: UIDatePicker!
    @IBOutlet var cookingTimePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var cameraIcon: UIImageView!
    var imageData: Data?
    
    var categories: [String] = []
    
    let numberRegex = try! NSRegularExpression(pattern: #"\d+(\.\d+){0,1}"#)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeImageView.layer.cornerRadius = recipeImageView.frame.width/2
        cameraIcon.layer.cornerRadius = cameraIcon.frame.width/4
    }

    @IBAction func stepperPressed(_ sender: UIStepper) {
        // replace the text field text with the value in the stepper
        guard let text = yieldField.text else {return}
        let mutableText = NSMutableString(string: text)
        if numberRegex.replaceMatches(in: mutableText, range: NSRange(text.startIndex..., in: text), withTemplate: sender.value.formatted(.number)) > 0 {
            yieldField.text = String(mutableText)
        } else {
            yieldField.text = sender.value.formatted(.number)
        }
    }
    
    @IBAction func yieldEdited(_ sender: UITextField) {
        // store first number in the text field as the value in the stepper
        guard let text = yieldField.text else {return}
        if let numberNSRange = numberRegex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))?.range(at: 0),
           let numberRange = Range(numberNSRange, in: text) {
            yieldStepper.value = (try? Double(String(text[numberRange]), format: .number)) ?? yieldStepper.value
        }
    }
    
    
    @IBAction func recipeImagePressed(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alertController.addAction(UIAlertAction(title: "Choose Photo", style: .default) { _ in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                })
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alertController.addAction(UIAlertAction(title: "Take Photo", style: .cancel) { _ in
                    imagePicker.sourceType = .camera
                })
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alertController.popoverPresentationController?.sourceView = sender.view
            present(alertController, animated: true)

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        if let imageData = image?.jpegData(compressionQuality: 0.9),
           let image = UIImage(data: imageData) {
            self.imageData = imageData
            recipeImageView.image = image
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    
    @IBSegueAction func openCategoriesSelector(_ coder: NSCoder) -> CategoriesSelectorTableViewController? {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        return CategoriesSelectorTableViewController(coder: coder, categories: categories)
    }
    
    @IBAction func unwindFromCategoriesSelectionCancel(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindFromCategoriesSelectionDone(unwindSegue: UIStoryboardSegue) {
        let categoriesSelector = unwindSegue.source as! CategoriesSelectorTableViewController
        categories = [String](categoriesSelector.selectedCategories)
        if categories.isEmpty {
            categoriesLabel.text = "None"
        } else {
            categoriesLabel.text = categories.joined(separator: ", ")
        }
    }
    
}
