//
//  HistoryDetailViewController.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import Foundation
import UIKit
import FSCalendar

class HistoryDetailViewController: UIViewController {
    
    
    let dayOfWeek = ["SUN", "MON", "TUE", "WED", "THR", "FRI", "SAT"]
    var result = [(String, Int, Int)]()
    @IBOutlet weak var pillDosageTableHight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var datesRangeLabel: UILabel!
    @IBOutlet weak var fsCalendarHeaderLabel: UILabel!
    
    private var startDate: Date?
    private var endDate: Date?
    private var datesRange: [Date?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result = CoreDataManager.shared.fetchPillInformationLastWeek()
        setDelegate()
        setStyle()
        
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.allowsMultipleSelection = true
        fsCalendar.isHidden = true
        
        fsCalendar.tintColor = UIColor.AColor.accent
        fsCalendar.appearance.todayColor = UIColor.AColor.accent.withAlphaComponent(0.5)
        fsCalendar.scrollEnabled = false
        fsCalendar.appearance.weekdayFont = UIFont.AFont.calendarWeekDayFont
        fsCalendar.headerHeight = 0
        fsCalendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        
//        fsCalendar.locale = Locale(identifier: "US")
        for i in 0 ..< 7 {
            fsCalendar.calendarWeekdayView.weekdayLabels[i].text = dayOfWeek[i]
        }
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        datesRangeLabel.isUserInteractionEnabled = true
        datesRangeLabel.addGestureRecognizer(tapRecognizer)
        
        
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setStyle() {
        let nib = UINib(nibName: "HistoryDetailProgressViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryDetailProgressViewCell")
        tableView.isScrollEnabled = false
        pillDosageTableHight.constant = CGFloat(25 + (result.count == 0 ? 1 : result.count) * 72)
        self.navigationController?.navigationBar.tintColor = .AColor.accent
        self.navigationItem.title = "한 눈에 보기"
        //self.reportViewTitle.font = UIFont.AFont.navigationTitle
    }
    
    @objc private func tapRecognizer(_ sender: UITapGestureRecognizer) {
        fsCalendar.isHidden.toggle()
    }
    
}

extension HistoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.isEmpty ? 1 : result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailProgressViewCell", for: indexPath) as! HistoryDetailProgressViewCell

        if result.count == 0 {
            
            cell.pillName.text = "아직 복용한 약이 없어요"
            cell.pillDosage.isHidden = true
            cell.pillRatio.isHidden = true
            cell.pillName.textColor = UIColor.AColor.gray
    
        } else {
           
            cell.pillName.text = result[indexPath.row].0
            cell.pillDosage.progress = Float(result[indexPath.row].1) / Float(result[indexPath.row].2)
            
            cell.pillRatio.text = result[indexPath.row].1 == 0 ? "" : String("\(result[indexPath.row].1) / \(result[indexPath.row].2)" )
        }
        return cell
    }
    
    
}

extension HistoryDetailViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if startDate == nil {
            startDate = date
            datesRange = [startDate!]
            return
        }
        
        if startDate != nil && endDate == nil {
            if date <= startDate! {
                fsCalendar.deselect(startDate!)
                startDate = date
                datesRange = [startDate!]
                return
            }
            
            
            let range = datesRange(from: startDate!, to: date)
            
            endDate = range.last
            
            for day in range {
                fsCalendar.select(day)
            }
            
            datesRange = range
            
            return
        }
        
        if startDate != nil && endDate != nil {
            for day in fsCalendar.selectedDates {
                fsCalendar.deselect(day)
            }
            
            startDate = nil
            endDate = nil
            datesRange = []
            
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDate != nil && endDate != nil {
            for day in fsCalendar.selectedDates {
                fsCalendar.deselect(day)
            }
            
            startDate = nil
            endDate = nil
            datesRange = []
        }
    }
    
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }

    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//
//        switch datesRange {
//        case .selectedDate:
//            return UIColor.AColor.accent
//        case .datesRange:
//            return UIColor.AColor.accent.withAlphaComponent(0.5)
//        }
//    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
    }

}

