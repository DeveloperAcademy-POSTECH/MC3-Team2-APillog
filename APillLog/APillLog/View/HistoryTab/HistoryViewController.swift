//
//  HistoryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class HistoryViewController: UIViewController, CalendarViewDelegate {
    var selectedDate = Date()
    
    func fetchDate(date: Date) {
        historyData = coredataManager.fetchHistory(selectedDate: date)
        tableView.reloadData()
    }
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    let coredataManager: CoreDataManager = CoreDataManager()
    var historyData = [History]()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.AColor.background
        self.tableView.backgroundColor = UIColor.AColor.background
        calendarView.delegate = self
        historyData = coredataManager.fetchHistory(selectedDate: Date())
        
        registerNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyData = coredataManager.fetchHistory(selectedDate: selectedDate)
        tableView.reloadData()
    }
}


// MARK: Extension
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView Funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.createdTime.text = dateformatter.string(from:historyData[indexPath.row].createTime ?? Date())
        cell.pillName.text = fetchPillNameText(index: indexPath.row)
        cell.sideEffect.text = historyData[indexPath.row].sideEffect?.joined(separator: " /")
        cell.medicinalEffect.text = historyData[indexPath.row].medicinalEffect?.joined(separator: " /")
        cell.detailContext.text = historyData[indexPath.row].detailContext

        if cell.pillName.text == "" { cell.stackViewPillName.isHidden = true }
        if cell.sideEffect.text == "" { cell.stackViewSideEffect.isHidden = true }
        if cell.medicinalEffect.text == "" { cell.stackViewMedicinalEffect.isHidden = true }
        if cell.detailContext.text == "" { cell.stackViewDetailContext.isHidden = true }
        
        return cell
    }
    
    private func registerNib() {
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    private func fetchPillNameText(index: Int) -> String? {
        if let pillName = historyData[index].pillName {
            return pillName + historyData[index].dosage!
        }
        
        if let pillName = historyData[index].names {
            let zipped = zip(pillName, historyData[index].dosages!).map{ "\($0) \($1)"  }
            return zipped.joined(separator: "\n")
        }
        
        return nil
    }
}
