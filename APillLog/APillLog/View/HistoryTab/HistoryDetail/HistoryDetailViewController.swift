//
//  HistoryDetailViewController.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import Foundation
import UIKit
import HealthKit


class HistoryDetailViewController: UIViewController {
    
    var result = [(String, Int, Int)]()
    @IBOutlet weak var pillDosageTableHight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var reportViewTitle: UILabel!
    
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = CoreDataManager.shared.fetchPillInformationLastWeek()
        setDelegate()
        setStyle()
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setStyle() {
        let nib = UINib(nibName: "HistoryDetailProgressViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryDetailProgressViewCell")
        tableView.isScrollEnabled = false
        pillDosageTableHight.constant = CGFloat(25 + (result.count == 0 ? 1 : result.count) * 72)
        self.navigationController?.navigationBar.tintColor = .AColor.accent
        self.navigationItem.title = "한 눈에 보기"
        self.reportViewTitle.font = UIFont.AFont.navigationTitle
    }
}

extension HistoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.isEmpty ? 1 : result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailProgressViewCell", for: indexPath) as! HistoryDetailProgressViewCell

        if result.count == 0 {
            
            cell.pillName.text = "아직 복용한 약이 없어요"
            cell.pillDosage.isHidden = true
            cell.pillRatio.isHidden = true
            cell.pillName.textColor = UIColor.AColor.gray
    
        } else {
           
            cell.pillName.text = result[indexPath.row].0
            cell.pillDosage.progress = Float(result[indexPath.row].1) / Float(result[indexPath.row].2)
            
            cell.pillRatio.text = result[indexPath.row].1 == 0 ? "" : String("\(result[indexPath.row].1) / \(result[indexPath.row].2)" )
        }
        return cell
    }
}

// HealthKit
extension HistoryDetailViewController {
    private func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if chk {
                // 접근 허용함
                
            } else {
                // 접근 불허함
                
            }
        }
    }
}
