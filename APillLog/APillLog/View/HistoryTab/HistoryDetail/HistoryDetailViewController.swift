//
//  HistoryDetailViewController.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import Foundation
import UIKit


class HistoryDetailViewController: UIViewController {
    
    var pillNames = ["콘서타", "메디키넷", "어쩌고", "저쩌고"]
    var pillDosage: [Float] = [0.5, 0.3, 0.7, 0.8]
    var historyData = [History]()
    var result = [(String, Int, Int)]()
    @IBOutlet weak var pillDosageTableHight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HistoryDetailProgressViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryDetailProgressViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        pillDosageTableHight.constant = CGFloat(pillNames.count * 80)
        result = CoreDataManager.shared.fetchPillInformationLastWeek()
    }
    
}

extension HistoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailProgressViewCell", for: indexPath) as! HistoryDetailProgressViewCell
        
        cell.pillName.text = result[indexPath.row].0
        cell.pillDosage.progress = Float(result[indexPath.row].1) / Float(result[indexPath.row].2)
        print("DEBUG: " , result[indexPath.row])
        return cell
    }
    
    
}
