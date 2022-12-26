//
//  IngredientsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    @IBOutlet var ingredientsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let inputView = UIInputView(frame: frame, inputViewStyle: .keyboard)
        let scrollView = UIScrollView(frame: frame)
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 2000, height: scrollView.frame.height))
        
        [
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
        ].forEach {
            v in
            v.text = "Hello"
            stackView.addArrangedSubview(v)
        }
        
        stackView.spacing = 30
        scrollView.backgroundColor = .clear
        scrollView.addSubview(stackView)
        scrollView.contentSize = CGSize(width: 2000, height: 50)
        inputView.addSubview(scrollView)
        ingredientsTextView.inputAccessoryView = inputView
        
    }
    

}
