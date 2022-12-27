//
//  SettingsViewController.swift
//  Cooking-Recipe-App
//
//  Created by Student on 05/12/2022.
//

import UIKit

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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        cell.titles.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        switch indexPath.section {
        case 0:
            cell.titles.text = sets[indexPath.row]
        default:
            cell.titles.text = sets[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        cell.titles.font = UIFont.boldSystemFont(ofSize: 20)
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
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
}
