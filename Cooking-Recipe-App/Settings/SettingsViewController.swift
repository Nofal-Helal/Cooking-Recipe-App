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
            alertController.addAction(UIAlertAction(title: "Metric", style: .default) { _ in self.setMeasurementSystem(.Metric)})
            alertController.addAction(UIAlertAction(title: "US Customary Units", style: .default) { _ in self.setMeasurementSystem(.US)})
            alertController.addAction(UIAlertAction(title: "UK Imperial", style: .default) { _ in self.setMeasurementSystem(.Imperial)})
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
            //for display them row
        case 1:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Display Theme", message: setTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "System", style: .default) { _ in SettingsViewController.setDisplayTheme(.System) })
            alertController.addAction(UIAlertAction(title: "Light", style: .default) { _ in SettingsViewController.setDisplayTheme(.Light) })
            alertController.addAction(UIAlertAction(title: "Dark", style: .default) { _ in SettingsViewController.setDisplayTheme(.Dark)})
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
    static func setDisplayTheme(_ displayTheme: DisplayTheme) {
        let userDefaults = UserDefaults.standard
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            
            switch displayTheme {
            case .Light:
                appDelegate?.overrideUserInterfaceStyle = .light
            case .Dark:
                appDelegate?.overrideUserInterfaceStyle = .dark
            case .System:
                appDelegate?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            }
            
            userDefaults.set(displayTheme.rawValue, forKey: "Display Theme")
        }
    }
    // for measurement system
    func setMeasurementSystem(_ measurementSystem: MeasurementSystem){
        userDefaults.set(measurementSystem.rawValue, forKey: "Measurement System")
    }

    
}


