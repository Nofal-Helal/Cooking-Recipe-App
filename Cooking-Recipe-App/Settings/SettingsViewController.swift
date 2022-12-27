//
//  SettingsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 05/12/2022.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sets.count
        default:
            return 0
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        cell.titles.font = UIFont.boldSystemFont(ofSize: 20)
        cell.titles.text = headers[section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Measurement System", message: setTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "US Customary Units", style: .default) { _ in })
            alertController.addAction(UIAlertAction(title: "Metric", style: .default) { _ in })
            alertController.addAction(UIAlertAction(title: "UK Imperial", style: .destructive) { _ in })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
        case 1:
            let setTitle = sets[indexPath.row]
            
            let alertController = UIAlertController(title: "Display Theme", message: setTitle, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Light", style: .default) { _ in self.DisplayTheme(num: 1) })
            alertController.addAction(UIAlertAction(title: "Dark", style: .default) { _ in self.DisplayTheme(num: 2)})
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alertController, animated: true)
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
    
    func DisplayTheme(num: Int){
        
        if(num == 1){
            overrideUserInterfaceStyle = .light

        }else if(num == 2){
            overrideUserInterfaceStyle = .dark
            
        }
            
        
    }
    
}
