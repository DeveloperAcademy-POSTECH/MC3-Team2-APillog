//
//  ManageDosingViewController.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/20.
//

import Foundation
import UIKit

class ManageDosingViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    let cellIdentifier = "ManageDosingCell"
    let dummies: [dummy] = [
        dummy(name: "콘서타", dosage: "18mg", dosingCycle: 3, isShowing: true, createTime: Date()),
        dummy(name: "메디피진", dosage: "10mg", dosingCycle: 1, isShowing: true, createTime: Date()),
        dummy(name: "인데졸정", dosage: "", dosingCycle: 6, isShowing: true, createTime: Date()),
        dummy(name: "콘서타", dosage: "18mg", dosingCycle: 4, isShowing: true, createTime: Date())
    
    ]
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        viewTitle.font = UIFont.AFont.navigationTitle
    }
}

extension ManageDosingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dummies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ManageDosingTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageDosingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dosingCycleLabel.font = UIFont.AFont.caption
        cell.nameAndDosageLabel.font = UIFont.AFont.tableViewBody
        
        cell.dosingCycleLabel.textColor = UIColor.AColor.gray
        cell.nameAndDosageLabel.textColor = UIColor.AColor.black
        
        cell.nameAndDosageLabel.text = dummies[indexPath.row].nameAndDosage()
        cell.dosingCycleLabel.text = dummies[indexPath.row].dosingCycleToString()
        
        return cell
    }
}

extension ManageDosingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

// ManageDosingTableViewCell
class ManageDosingTableViewCell: UITableViewCell {
    // MARK: @IBOutlet
    @IBOutlet weak var dosingCycleLabel: UILabel!
    @IBOutlet weak var nameAndDosageLabel: UILabel!
    @IBOutlet weak var isShowingSwitch: UISwitch!
}

struct dummy {
    let name: String
    let dosage: String
    let dosingCycle: Int
    let isShowing: Bool
    let createTime: Date
    
    func nameAndDosage() -> String {
        return name + " " + dosage
    }
    
    func dosingCycleToString() -> String {
        var str = ""
        var cycle = dosingCycle
        
        if dosingCycle % 2 == 1 {
            str.append("아침")
        }
        
        cycle = cycle / 2
        if dosingCycle % 2 == 1 {
            if !(str.isEmpty) { str.append(", ") }
            str.append("점심")
        }
        
        cycle = cycle / 2
        if dosingCycle % 2 == 1 {
            if !(str.isEmpty) { str.append(", ")}
            str.append("저녁")
        }
        
        return str
    }
}
