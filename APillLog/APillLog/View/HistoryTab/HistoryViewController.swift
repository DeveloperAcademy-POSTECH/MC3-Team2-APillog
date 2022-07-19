//
//  HistoryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let dummyData = getDummyData()
    let category = ["약 복용", "불편 사항", "개선 사항", "추가 기록"]
    let pillText = ["두통", "콘서타 18mg", "인데놀 1정", "눈물 촉촉"]
    let timeText = ["7:00", "8:00", "12:00", "14:00"]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: TableView Funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyData.count
    }
    
    // TODO: CoreData 값으로 변경
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.createTime.text = dummyData[indexPath.row].createTime
        cell.pillName.text = dummyData[indexPath.row].pillName?.joined(separator: "\n")
        cell.sideEffect.text = dummyData[indexPath.row].conditionContext?[0]
        cell.medicinalEffect.text = dummyData[indexPath.row].conditionContext?[1]
        cell.detailContext.text = dummyData[indexPath.row].conditionContext?[2]
        
        if cell.pillName.text == nil { cell.stackViewPillName.isHidden = true }
        if cell.sideEffect.text == nil { cell.stackViewSideEffect.isHidden = true }
        if cell.medicinalEffect.text == nil { cell.stackViewMedicinalEffect.isHidden = true }
        if cell.detailContext.text == nil { cell.stackViewDetailContext.isHidden = true }
        
        return cell
    }
}


// MARK: Test를 위한 코드
struct history {
    var pillName: [String]?
    var isMainPill: String?
    var conditionContext: [String?]?
    var createTime: String
}

func getDummyData() -> [history] {
    [
        history(pillName: nil, isMainPill: nil, conditionContext: ["두통", nil, nil], createTime: "07:00"),
        history(pillName: ["콘서타 18mg"], isMainPill: "main", conditionContext: nil, createTime: "08:00"),
        history(pillName: ["콘서타 18mg","인데놀 1정", "콘서타 18mg","인데놀 1정"], isMainPill: "main", conditionContext: nil, createTime: "11:00"),
        history(pillName: nil, isMainPill: nil, conditionContext: ["두근거림", "눈물촉촉", "아침에 일어났을 때 두통이 심했어요"], createTime: "15:00")
    ]
}
