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
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
    }
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyViewGuideLabel: UILabel!
    
    let coredataManager: CoreDataManager = CoreDataManager()
    var historyData = [History]()
    var guideLabelHidden = true {
        didSet {
            historyViewGuideLabel.isHidden = guideLabelHidden
        }
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        registerNib()
        setDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyData = coredataManager.fetchHistory(selectedDate: selectedDate)
        tableView.reloadData()
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
    }
    
    private func setDelegate() {
        calendarView.delegate = self
        historyData = coredataManager.fetchHistory(selectedDate: Date())
        tableView.delegate = self
        tableView.dataSource = self
        historyViewGuideLabel.textColor = UIColor.AColor.gray
    }
    
    private func setStyle() {
        view.backgroundColor = UIColor.AColor.background
        tableView.backgroundColor = UIColor.AColor.background
        
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
        cell.pillName.text = historyData[indexPath.row].pillName
        cell.sideEffect.text = historyData[indexPath.row].sideEffect?.joined(separator: " / ")
        cell.medicinalEffect.text = historyData[indexPath.row].medicinalEffect?.joined(separator: " / ")
        cell.detailContext.text = historyData[indexPath.row].detailContext

        if cell.pillName.text == nil { cell.stackViewPillName.isHidden = true }
        if cell.sideEffect.text == "" { cell.stackViewSideEffect.isHidden = true }
        if cell.medicinalEffect.text == "" { cell.stackViewMedicinalEffect.isHidden = true }
        if  cell.detailContext.text == "" { cell.stackViewDetailContext.isHidden = true }
        
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
