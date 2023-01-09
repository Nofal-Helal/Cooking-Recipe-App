//
//  IngredientsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 26/12/2022.
//

import UIKit

class RecipeTextEditingViewController: UIViewController {
    
    // the text view for inputting ingredients or directions
    @IBOutlet var textView: UITextView!
    
    let userDefaults = UserDefaults.standard
    
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
        let stackView = UIStackView()
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the buttons
        for button in barButtons() {
            stackView.addArrangedSubview(button)
            addSeparator(in: stackView)
        }
        // remove last separator
        stackView.arrangedSubviews.last?.removeFromSuperview()
        
        // resize
        stackView.layoutIfNeeded()
        stackView.widthAnchor.constraint(equalToConstant: stackView.bounds.width).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        scrollView.contentSize = CGSize(width: stackView.frame.width + 32, height: 50)
        inputView.addSubview(scrollView)
        textView.inputAccessoryView = inputView
        
    }
    
    fileprivate func addSeparator(in stackView: UIStackView) {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    // decide what buttons to show in the bar
    func barButtons() -> [UIButton] {
        var symbols = [String]()
        // fractions
        symbols.append(contentsOf: ["¼","⅓","½","⅔","¾"])
        // units
        symbols.append(contentsOf: shortcuts())
        
        let buttons: [UIButton] = symbols.map { s in
            let button = UIButton()
            button.setTitle(s, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(barButtonPressed(_ :)), for: .touchUpInside)
            return button
        }
        
        return buttons
    }
    
    @IBAction func barButtonPressed(_ sender: UIButton) {
        textView.insertText(sender.currentTitle! + " ")
    }
    
    // adjust text view inset when the keyboard is shown
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }

    func shortcuts() -> [String] {
        let measurementSystem = MeasurementSystem(rawValue: userDefaults.integer(forKey: "Measurement System"))
        
        switch measurementSystem {
        case .Metric, .none:
            return ["°C", "tsp", "tbsp", "cup", "g", "mL", "kg", "L"]
        case .Imperial:
            return ["°F", "tsp", "tbsp", "cup", "fl oz", "oz", "lb"]
        case .US:
            return ["°F", "tsp", "tbsp", "cup", "fl oz", "oz", "lb"]
        }
    }
}
