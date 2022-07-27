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
    @IBOutlet weak var emptyDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    var coreDataManager: CoreDataManager = CoreDataManager()
    
    let cellIdentifier = "ManageDosingCell"
    var primaryPillList: [PrimaryPill] = []
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        self.viewTitle.font = UIFont.AFont.navigationTitle
        self.primaryPillList = self.coreDataManager.fetchPrimaryPill()
        self.tableView.delegate = self
        let nibName = UINib(nibName: "EmptyDosingTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "emptyDosingCell")
    }
 
  
    // MARK: Function
    private func dosingCycleToString(dosingCycle: Int16) -> String {
        var result = ""
        
        if dosingCycle & 1 == 1 {
            result.append("아침")
        }
        
        if dosingCycle & 2 == 2 {
            if result.isEmpty == false {
                result.append(", ")
            }
            
            result.append("점심")
        }
        
        if dosingCycle & 4 == 4 {
            if result.isEmpty == false {
                result.append(", ")
            }
            result.append("저녁")
        }
        
        return result
    }
    
    // MARK: @IBAction
    // delegate 등록을 위해 함수로 뷰 호출
    @IBAction func tapAddButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "AddPrimaryPill", bundle:nil)
        guard let nextViewController: AddPrimaryPillViewController = storyBoard.instantiateViewController(withIdentifier: "AddPrimaryPillView") as? AddPrimaryPillViewController else { return }
        nextViewController.delegate = self
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ManageDosingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.primaryPillList.count == 0 ? 1 : self.primaryPillList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.primaryPillList.count == 0 {
            guard let emptyCell: EmptyDosingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "emptyDosingCell", for: indexPath) as? EmptyDosingTableViewCell else {
                return UITableViewCell()
            }

            emptyCell.emptyDescription?.text = "복욕할 약 목록이 비어있어요!"
            emptyCell.emptyDescription?.textColor = UIColor.AColor.gray
            emptyCell.emptyDescription?.font = UIFont.AFont.explainText


            return emptyCell

        } else {
            guard let cell: ManageDosingTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageDosingTableViewCell else {
                return UITableViewCell()
            }
                    
            cell.dosingCycleLabel.font = UIFont.AFont.caption
            cell.nameAndDosageLabel.font = UIFont.AFont.tableViewBody
            
            cell.dosingCycleLabel.textColor = UIColor.AColor.gray
            cell.nameAndDosageLabel.textColor = UIColor.AColor.black
            
            
            cell.primaryPill = primaryPillList[indexPath.row]
            cell.nameAndDosageLabel.text = (primaryPillList[indexPath.row].name ?? "NONAME") + " " + (primaryPillList[indexPath.row].dosage ?? "NODOSAGE")
            cell.dosingCycleLabel.text = dosingCycleToString(dosingCycle: primaryPillList[indexPath.row].dosingCycle)
            cell.isShowingSwitch.isOn = primaryPillList[indexPath.row].isShowing
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            coreDataManager.deletePrimaryPill(pill: primaryPillList[indexPath.row])
            
            primaryPillList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else {
            return
        }
    }
}

extension ManageDosingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

// 약 추가 이후 뷰 업데이트를 위해 델리게이트 패턴 사용
extension ManageDosingViewController: AddPrimaryPillViewControllerDelegate {
    func didAddPrimaryPill() {
     
        self.primaryPillList = self.coreDataManager.fetchPrimaryPill()
        let indexPath = IndexPath(row: primaryPillList.count-1, section: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath] , with: .automatic)
        tableView.endUpdates()
        
    }
}



// ManageDosingTableViewCell
class ManageDosingTableViewCell: UITableViewCell {
    
    // MARK: @IBOutlet
    @IBOutlet weak var dosingCycleLabel: UILabel!
    @IBOutlet weak var nameAndDosageLabel: UILabel!
    @IBOutlet weak var isShowingSwitch: UISwitch!
    
    
    // MARK: Property
    var primaryPill: PrimaryPill? = nil
    var coreDataManager = CoreDataManager()
    
    // MARK: @IBAction
    @IBAction func toggleIsShowing(_ sender: UISwitch) {
        coreDataManager.togglePrimaryPillIsShowing(pill: primaryPill!)
       // let primaryPillList = coreDataManager.fetchPrimaryPill()
    
     
    }
}

