//
//  CategoryAddEditViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 29/12/2022.
//

import UIKit

class CategoryAddEditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var category: Category?
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var categoryImageData: Data?
    
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
        if category != nil {
            navigationItem.title = "Edit Category"
            categoryTextField.placeholder = "Rename Category"
            saveButton.setTitle("Save", for: .normal)
            
            if let imageData = category!.imageData {
                categoryImage.image = UIImage(data: imageData)
            } else {
                categoryImage.image = UIImage(named: "placeholder")
            }
            categoryTextField.text = category?.title
        }
    }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
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
        let image = info[.originalImage] as? UIImage
        if let imageData = image?.jpegData(compressionQuality: 0.9),
           let image = UIImage(data: imageData) {
            self.categoryImageData = imageData
            categoryImage.image = image
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
