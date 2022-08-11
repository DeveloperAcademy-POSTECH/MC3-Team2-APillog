//
//  DiaryStorageViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/08/11.
//

import UIKit
import FSCalendar

class DiaryStorageViewController: UIViewController, UITableViewDelegate , UITableViewDataSource
{
    private var date = Date()
    var selectedBody = ""
    var selectedDate = ""
    var myCBT : [CBT] = [CBT()]

    @IBOutlet weak var DiaryCalendar: CalendarMonth!
    @IBOutlet weak var storageTableView: UITableView!
    @IBOutlet weak var storageHeight: NSLayoutConstraint!
    let cellIdentifier = "storageCustomCell"
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
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        if self.storageTableView.contentSize.height == 0{
            self.storageHeight?.constant = 200
        }
        else if self.storageTableView.contentSize.height > 400{
            self.storageHeight?.constant = 385
        }
        else{
            self.storageHeight?.constant = self.storageTableView.contentSize.height + 100
        }

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

//extension Date {
//    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
//        calendar.isDate(self, equalTo: date, toGranularity: component)
//    }
//    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
//
//    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
//
//}
