//
//  SettingsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 05/12/2022.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var textF: UITextField!
    var headers = ["Settings","Stay toned"]
    var sets = ["Measurement System","Display Theme","Rate US"]
    var n: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerTableCells()
        
    }
    
    func registerTableCells(){
        tableView.register(UINib(nibName: "HeaderTitleCell", bundle: nil), forCellReuseIdentifier: "HeaderTitleCell")
    }
    
    func ImageTapped() {
        userName.isHidden = true
                textF.isHidden = false
                textF.text = userName.text
    }
    func textFieldShouldReturn(userText: UITextField) -> Bool {
            userText.resignFirstResponder()
            textF.isHidden = true
            userName.isHidden = false
            userName.text = textF.text
            return true
        }
    
    

}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource{
    //how many headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    //return number how rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sets.count
        default:
            return 0
        }
    }
    
    //prints rows and change design
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        cell.titles.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.tag = indexPath.row
        switch indexPath.section {
        case 0:
            cell.titles.text = sets[indexPath.row]
        default:
            return UITableViewCell()
        }

        return cell
    }
    //prints header and change design
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        cell.titles.font = UIFont.boldSystemFont(ofSize: 20)
        cell.titles.text = headers[section]
        return cell
    }
    //design stuff
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 60
        }
    }
    //this too
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        default:
            return 40
        }
    }
    //also this
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return 20
        }
    }
    //when a row is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            //for measurement system row
        case 0:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Measurement System", message: setTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "US Customary Units", style: .default) { _ in self.measurementSys(num: 1)})
            alertController.addAction(UIAlertAction(title: "Metric", style: .default) { _ in self.measurementSys(num: 2)})
            alertController.addAction(UIAlertAction(title: "UK Imperial", style: .destructive) { _ in self.measurementSys(num: 3)})
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
            //for display them row
        case 1:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Display Theme", message: setTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Light", style: .default) { _ in self.DisplayTheme(num: 1) })
            alertController.addAction(UIAlertAction(title: "Dark", style: .default) { _ in self.DisplayTheme(num: 2)})
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
            //just extra option (look good) :)
        case 2:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Give US 5 STARS", message: setTitle, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            alertController.addAction(UIAlertAction(title: "NO", style: .default) { _ in })
            
            self.present(alertController, animated: true)
        
        default:
            ()
        }
    }
    //funtion to change between dark and light modes
    func DisplayTheme(num: Int){
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if(num == 1){
                appDelegate?.overrideUserInterfaceStyle = .light
                n[0] = 1
                return
            }else if(num == 2){
                appDelegate?.overrideUserInterfaceStyle = .dark
                n[0] = 2
                return
            }
        }
    }
    // for measurement system
    func measurementSys(num: Int){
        if(num == 1){
            n[1] = 1
        }else if (num == 2){
            n[1] = 2
        }else if (num == 3){
            n[1] = 3
        }
    }
    //creating fileManager
    static var archiveURL: URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            documentsURL.appendPathComponent("Settings.plist")
        return documentsURL
    }
    //saving username, theme and measure
    static func saveRecipes(_ n: Int) {
        let plistEncoder = PropertyListEncoder()
        if let encodedRecipes = try? plistEncoder.encode(n) {
            try? encodedRecipes.write(to: archiveURL)
        }
    }
    //load the stuff
    /*static func loadRecipes() -> [Recipe]? {
        let plistDecoder = PropertyListDecoder()
        if let encodedRecipes = try? Data(contentsOf: archiveURL),
           let decodedRecipes = try? plistDecoder.decode([Recipe].self, from: encodedRecipes) {
            return decodedRecipes
        }
        return nil
    }*/
    
}
