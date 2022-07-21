//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class DiaryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var mistakeTableView: UITableView!
    
    
    
    var coredataManager: CoreDataManager = CoreDataManager()
    let cellIdentifier = "customCell"
    var myCBT : [CBT] = [CBT()]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCBT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCellTableViewCell = self.mistakeTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCellTableViewCell
        cell.cellUUID = myCBT[indexPath.row].cbtId ?? UUID()
        cell.cellTitle.text = myCBT[indexPath.row].cbtContext ?? "text"
        cell.cellTitle.font = UIFont.AFont.tableViewTitle
        cell.cellTitle.textColor = UIColor.AColor.black
        cell.cellDate.text = myCBT[indexPath.row].selectDate
        cell.cellDate.font = UIFont.AFont.tableViewBody
        cell.cellDate.textColor = UIColor.AColor.gray
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mistakeTableView.delegate = self
        mistakeTableView.dataSource = self
        mistakeTableView.sectionHeaderHeight = 50
        mistakeTableView.sectionHeaderTopPadding = 0
        mistakeTableView.register(MyCustomHeader.self,
                                  forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myCBT = coredataManager.fetchCBT()
        myCBT = myCBT.sorted(by: {
            $0.selectDate!>$1.selectDate!
        })
        mistakeTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomHeader
        
        view.title.text = "작성했던 실수 노트들"
        view.title.font = UIFont.AFont.tableViewTitle
        
        return view
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


