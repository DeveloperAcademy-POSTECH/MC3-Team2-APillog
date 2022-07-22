//
//  HistoryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coredataManager: CoreDataManager = CoreDataManager()
    var historyData = [History]()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        historyData = coredataManager.fetchHistory(selectedDate: Date())
        registerNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        historyData = coredataManager.fetchHistory(selectedDate: Date())
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
        cell.sideEffect.text = historyData[indexPath.row].sideEffect?.joined(separator: ", ")
        cell.medicinalEffect.text = historyData[indexPath.row].medicinalEffect?.joined(separator: ", ")
        cell.detailContext.text = historyData[indexPath.row].detailContext

        if cell.pillName.text == nil { cell.stackViewPillName.isHidden = true }
        if cell.sideEffect.text == nil { cell.stackViewSideEffect.isHidden = true }
        if cell.medicinalEffect.text == nil { cell.stackViewMedicinalEffect.isHidden = true }
        if cell.detailContext.text == nil { cell.stackViewDetailContext.isHidden = true }
        
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
    
    // MARK: TestCode
    @IBAction func clicked() {
        coredataManager.addHistory(pillId: nil, pillName: nil, dosage: nil, isMainPill: nil, pillNames: nil, dosages: nil, sideEffect: ["두통"], medicinalEffect: nil, detailContext: nil)
        coredataManager.addHistory(pillId: nil, pillName: "콘서타", dosage: "18", isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
        coredataManager.addHistory(pillId: nil, pillName: nil, dosage: nil, isMainPill: true, pillNames: ["콘서타", "인데놀"], dosages: ["18mg", "1정"], sideEffect: nil, medicinalEffect: nil, detailContext: nil)
        coredataManager.addHistory(pillId: nil, pillName: nil, dosage: nil, isMainPill: nil, pillNames: nil, dosages: nil, sideEffect: ["두통", "어지러움", "눈알 건조"], medicinalEffect: ["상쾌함", "기분 좋음", "눈물 촉촉"], detailContext: "아침에 일어났을 때 두통이 심해졌고 그리고 어쩌고 저쩌고 되었네요 그래서 너무 속상하구요 약 바꾸고 싶어요.")
    }
}
