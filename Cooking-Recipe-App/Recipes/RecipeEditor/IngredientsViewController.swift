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
        
        // add observers for keyboard events
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        keyboardAccessoryInit()
        
    }
    
    fileprivate func keyboardAccessoryInit() {
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
    
    // adjust text view inset when the keyboard is shown
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            ingredientsTextView.contentInset = .zero
        } else {
            ingredientsTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        ingredientsTextView.scrollIndicatorInsets = ingredientsTextView.contentInset

        let selectedRange = ingredientsTextView.selectedRange
        ingredientsTextView.scrollRangeToVisible(selectedRange)
    }

}
