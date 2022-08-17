//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit
import WidgetKit

class DiaryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var mistakeTableView: UITableView!
    @IBOutlet weak var mistakeTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var diaryViewGuideLabel: UILabel!
    let cellIdentifier = "customCell"
    var myCBT : [CBT] = []
    var selectedBody = ""
    var selectedDate = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCBT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCellTableViewCell = self.mistakeTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCellTableViewCell
        cell.cellUUID = myCBT[indexPath.row].cbtId ?? UUID()
        cell.cellTitle.text = myCBT[indexPath.row].actionContext ?? "text"
        cell.cellTitle.font = UIFont.AFont.tableViewTitle
        cell.cellTitle.textColor = UIColor.AColor.black
        cell.cellDate.text = myCBT[indexPath.row].selectDate
        cell.cellDate.font = UIFont.AFont.tableViewBody
        cell.cellDate.textColor = UIColor.AColor.gray
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        
        filterDocument()
        super.updateViewConstraints()
        if self.myCBT.count == 0{
            self.mistakeTableViewHeight?.constant = 200
            
        }
        else if self.mistakeTableView.contentSize.height > 300 && UIScreen.main.bounds.height<700{
            self.mistakeTableViewHeight?.constant = 270
        }
        else if self.mistakeTableView.contentSize.height > 300{
            self.mistakeTableViewHeight?.constant = 370
        }
        else{
            self.mistakeTableViewHeight?.constant = self.mistakeTableView.contentSize.height + 55
        }
        self.mistakeTableView.isScrollEnabled = myCBT.count == 0 ? false : true
        diaryViewGuideLabel.isHidden = myCBT.count == 0 ? false : true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mistakeTableView.delegate = self
        mistakeTableView.dataSource = self
        mistakeTableView.sectionHeaderHeight = 50
        mistakeTableView.sectionHeaderTopPadding = 0
        mistakeTableView.register(MyCustomHeader.self,
                                  forHeaderFooterViewReuseIdentifier: "sectionHeader")
        mistakeTableView.rowHeight = 55
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myCBT = CoreDataManager.shared.fetchCBT()
        myCBT = myCBT.sorted(by: {
            $0.selectDate!>$1.selectDate!
        })
        mistakeTableView.reloadData()
        if myCBT.count == 0 {
            diaryViewGuideLabel.isHidden = false
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set("실수노트를 추가해주세요", forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
        else{
            diaryViewGuideLabel.isHidden = true
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(myCBT[0].actionContext, forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
        filterDocument()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if myCBT.count != 0{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(myCBT[0].actionContext, forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
        else{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set("실수노트를 추가해주세요", forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
        
    }
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomHeader
        
        view.title.text = "작성했던 에필로그들"
        view.title.font = UIFont.AFont.tableViewTitle
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBody = myCBT[indexPath.row].mistakeContext!
        selectedDate = myCBT[indexPath.row].selectDate!
        let storyboard = UIStoryboard(name: "DiaryView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "DiaryReadView") as! DiaryReadViewController
        vc.body = myCBT[indexPath.row].mistakeContext!
        vc.date = myCBT[indexPath.row].selectDate!
        vc.recognizeString = myCBT[indexPath.row].recognizeContext!
        vc.actionString = myCBT[indexPath.row].actionContext!
        vc.id = myCBT[indexPath.row].cbtId!
        vc.receivedCBT = myCBT[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let CBT = myCBT[indexPath.row]
            CoreDataManager.shared.deleteCBT(CBT: CBT)
            myCBT.remove(at: indexPath.row)
            self.mistakeTableView.reloadData()
            diaryViewGuideLabel.isHidden = myCBT.isEmpty ? false : true
            self.mistakeTableView.isScrollEnabled = myCBT.count == 0 ? false : true
            adjustTableHeight()
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(myCBT.isEmpty ? "실수노트를 추가해주세요" : myCBT[0].actionContext, forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func filterDocument(){
        myCBT = CoreDataManager.shared.fetchCBT()
        myCBT = myCBT.sorted(by: {
            $0.selectDate!>$1.selectDate!
        })
        var tempCbtArr : [CBT] =  []
        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "yyyy-MM"
        
        let baseDate = stringFormatter.string(from: Date())
        var baseDateArray = baseDate.components(separatedBy: "-")
        for i in 0..<myCBT.count{
            var cbtDateArray = myCBT[i].selectDate?.components(separatedBy: "-")
            if (baseDateArray[0] == cbtDateArray?[0])&&(baseDateArray[1] == cbtDateArray?[1]){
                tempCbtArr.append(myCBT[i])
            }
            
        }
        myCBT.removeAll()
        myCBT = tempCbtArr
        mistakeTableView.reloadData()
    }
    func adjustTableHeight(){
        if self.myCBT.count == 0{
            self.mistakeTableViewHeight?.constant = 200
            
        }
        else if self.mistakeTableView.contentSize.height > 300 && UIScreen.main.bounds.height<700{
            self.mistakeTableViewHeight?.constant = 270
        }
        else if self.mistakeTableView.contentSize.height > 300{
            self.mistakeTableViewHeight?.constant = 370
        }
        else{
            self.mistakeTableViewHeight?.constant = self.mistakeTableView.contentSize.height + 55
        }
        self.mistakeTableView.isScrollEnabled = myCBT.count == 0 ? false : true
        diaryViewGuideLabel.isHidden = myCBT.count == 0 ? false : true
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


