//
//  SettingsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 05/12/2022.
//

import UIKit
import Foundation



class SettingsViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var tableView: UITableView!
    let userDefaults = UserDefaults.standard
    var displayNum: Int = 1
    
    var headers = ["Settings","Stay toned"]
    var sets = ["Measurement System","Display Theme","Rate US"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerTableCells()
        
        
    }
    
    func registerTableCells(){
        tableView.register(UINib(nibName: "HeaderTitleCell", bundle: nil), forCellReuseIdentifier: "HeaderTitleCell")
    }
    
    //creating fileManager
    static var archiveURL: URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            documentsURL.appendPathComponent("Settings.plist")
        return documentsURL
    }
    //saving username, theme and measure
    static func saveSettings(_ n: String) {
        let plistEncoder = PropertyListEncoder()
        if let encodedSetting = try? plistEncoder.encode(n) {
            try? encodedSetting.write(to: archiveURL)
        }
    }
    //load the stuff
    /*static func loadSettings() -> [SettingsViewController]? {
        let plistDecoder = PropertyListDecoder()
        if let encodedSetting = try? Data(contentsOf: archiveURL),
           let decodedSetting = try? plistDecoder.decode([SettingsViewController].self, from: encodedSetting) {
            return decodedSetting
        }
        return nil
    }*/

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
            alertController.addAction(UIAlertAction(title: "Light", style: .default) { _ in SettingsViewController.DisplayTheme(num: 1) })
            alertController.addAction(UIAlertAction(title: "Dark", style: .default) { _ in SettingsViewController.DisplayTheme(num: 2)})
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
    static func DisplayTheme(num: Int){
        let userDefaults = UserDefaults.standard
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if(num == 1){
                appDelegate?.overrideUserInterfaceStyle = .light
                userDefaults.set(1, forKey: "Display Theme")
                return
            }else if(num == 2){
                appDelegate?.overrideUserInterfaceStyle = .dark
                userDefaults.set(2, forKey: "Display Theme")
                return
            }
        }
    }
    // for measurement system
    func measurementSys(num: Int){
        if(num == 1){

            userDefaults.set(1, forKey: "measurement System")
        }else if (num == 2){

            userDefaults.set(2, forKey: "measurement System")
        }else if (num == 3){

            userDefaults.set(3, forKey: "measurement System")
        }
    }

    
}


