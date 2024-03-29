//
//  DiaryStorageViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/08/11.
//

import UIKit
import FSCalendar
import WidgetKit

class DiaryStorageViewController: UIViewController
{
    private var date = Date()
    var selectedBody = ""
    var selectedDate = ""
    var myCBT : [CBT] = [CBT()]
    
    @IBOutlet weak var diaryStorageGuide: UILabel!
    @IBOutlet weak var DiaryCalendar: CalendarMonth!
    @IBOutlet weak var storageTableView: UITableView!
    @IBOutlet weak var storageHeight: NSLayoutConstraint!
    
    let cellIdentifier = "storageCustomCell"
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        if self.myCBT.count == 0{
            self.storageHeight?.constant = 200
        }
        else if self.storageTableView.contentSize.height > 300 && UIScreen.main.bounds.height<700{
            self.storageHeight?.constant = 385
        }
        else if self.storageTableView.contentSize.height > 400{
            self.storageHeight?.constant = 485
        }
        else{
            self.storageHeight?.constant = CGFloat(200 + myCBT.count * 50)
        }
        self.storageTableView.isScrollEnabled = myCBT.count == 0 ? false : true
        self.diaryStorageGuide.isHidden = myCBT.count == 0 ? false : true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendarView()
        
        storageTableView.delegate = self
        storageTableView.dataSource = self
        storageTableView.sectionHeaderHeight = 50
        storageTableView.sectionHeaderTopPadding = 0
        storageTableView.register(MyCustomHeader.self,
                                  forHeaderFooterViewReuseIdentifier: "sectionHeader")
        storageTableView.rowHeight = 55
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myCBT = CoreDataManager.shared.fetchCBT()
        myCBT = myCBT.sorted(by: {
            $0.selectDate!>$1.selectDate!
        })
        fetchDate(date: date)
        
        storageTableView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func adjustTableViewHeight(){
        if self.myCBT.count == 0{
            self.storageHeight?.constant = 200
        }
        else if self.storageTableView.contentSize.height > 400 && UIScreen.main.bounds.height<700{
            self.storageHeight?.constant = 385
        }
        else if self.storageTableView.contentSize.height > 400{
            self.storageHeight?.constant = 485
        }
        else{
            self.storageHeight?.constant = CGFloat(200 + myCBT.count * 50)
        }
        self.storageTableView.isScrollEnabled = myCBT.count == 0 ? false : true
        self.diaryStorageGuide.isHidden = myCBT.count == 0 ? false : true
    }
}

extension DiaryStorageViewController: CalendarMonthDelegate {
    
    func fetchDate(date: Date) {
        myCBT = CoreDataManager.shared.fetchCBT()
        myCBT = myCBT.sorted(by: {
            $0.selectDate!>$1.selectDate!
        })
        self.date = date
        var tempCbtArr : [CBT] =  []
        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "yyyy-MM"
        
        let baseDate = stringFormatter.string(from: date)
        var baseDateArray = baseDate.components(separatedBy: "-")
        for i in 0..<myCBT.count{
            var cbtDateArray = myCBT[i].selectDate?.components(separatedBy: "-")
            if (baseDateArray[0] == cbtDateArray?[0])&&(baseDateArray[1] == cbtDateArray?[1]){
                tempCbtArr.append(myCBT[i])
            }
            
        }
        myCBT.removeAll()
        myCBT = tempCbtArr
        storageTableView.reloadData()
        
    }
    
    func setCalendarView() {
        DiaryCalendar.delegate = self
    }
    
    func changeDateFormat(date: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        let calendarSelectedDate: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let currentTime: String = dateFormatter.string(from: Date())
        let takingTime = calendarSelectedDate + " " + currentTime
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: takingTime) ?? Date()
    }
    
    
    
}

extension DiaryStorageViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCBT.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCellTableViewCell2 = self.storageTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCellTableViewCell2
        cell.cellUUID = myCBT[indexPath.row].cbtId ?? UUID()
        cell.cellTitle.text = myCBT[indexPath.row].actionContext ?? "text"
        cell.cellTitle.font = UIFont.AFont.tableViewTitle
        cell.cellTitle.textColor = UIColor.AColor.black
        cell.cellDate.text = myCBT[indexPath.row].selectDate
        cell.cellDate.font = UIFont.AFont.tableViewBody
        cell.cellDate.textColor = UIColor.AColor.gray
        return cell
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
            self.storageTableView.isScrollEnabled = myCBT.count == 0 ? false : true
            self.storageTableView.reloadData()
            self.diaryStorageGuide.isHidden = myCBT.count == 0 ? true : false
            adjustTableViewHeight()
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(myCBT.isEmpty ? "실수노트를 추가해주세요" : myCBT[0].actionContext, forKey: "content")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
