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
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: date)
        tableView.reloadData()
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
    }
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyViewGuideLabel: UILabel!
    
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
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: selectedDate)
        
        tableView.reloadData()
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
    }
    
    private func setDelegate() {
        calendarView.delegate = self
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: Date())
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
            dateformatter.dateFormat = "a hh:mm"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.createdTime.text = dateformatter.string(from:historyData[indexPath.row].createTime ?? Date())
        
        
        if historyData[indexPath.row].pillName != nil {
            cell.pillName.text = "💊  " + historyData[indexPath.row].pillName!
        } else {
            cell.pillName.text = historyData[indexPath.row].pillName
        }
        cell.sideEffect.text = historyData[indexPath.row].sideEffect?.joined(separator: " / ")
        cell.detailContext.text = historyData[indexPath.row].detailContext

        if cell.pillName.text == nil || cell.pillName.text == "" {
            cell.stackViewPillName.isHidden = true
            cell.pillLabelView.isHidden = true
        } else {
            cell.stackViewPillName.isHidden = false
            cell.pillLabelView.isHidden = false
        }
        if cell.sideEffect.text == nil || cell.sideEffect.text == "" {
            cell.stackViewSideEffect.isHidden = true
            cell.sideEffectLabelView.isHidden = true
        } else {
            cell.stackViewSideEffect.isHidden = false
            cell.sideEffectLabelView.isHidden = false
        }
        if cell.detailContext.text == nil || cell.detailContext.text == "" {
            cell.stackViewDetailContext.isHidden = true
            cell.detailContextLabelView.isHidden = true
        } else {
            cell.stackViewDetailContext.isHidden = false
            cell.detailContextLabelView.isHidden = false
        }
        
        return cell
    }
    
    private func registerNib() {
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "historyTableViewCell")
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
