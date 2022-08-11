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
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
    
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
        
        fsCalendar.appearance.todayColor = UIColor.AColor.accent.withAlphaComponent(0.5)
        fsCalendar.scrollEnabled = false
        fsCalendar.appearance.weekdayFont = UIFont.AFont.calendarWeekDayFont
        fsCalendar.headerHeight = 0
        
        
        dayOfWeek.indices.forEach { index in
            fsCalendar.calendarWeekdayView.weekdayLabels[index].text = dayOfWeek[index]
        }
        
        
        // 기간 디자인 작업
        fsCalendar.today = nil
        fsCalendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        fsCalendar.swipeToChooseGesture.isEnabled = true
        
        let scopeGuesture = UIPanGestureRecognizer(target: fsCalendar, action: #selector(fsCalendar.handleScopeGesture(_:)))
        fsCalendar.addGestureRecognizer(scopeGuesture)
        
        
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
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.fsCalendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        
        if startDate == nil {
            startDate = date
            datesRange = [startDate!]
            self.configureVisibleCells()
            return
        }
        
        if startDate != nil && endDate == nil {
            if date <= startDate! {
                fsCalendar.deselect(startDate!)
                startDate = date
                datesRange = [startDate!]
                self.configureVisibleCells()
                return
            }
            
            
            let range = datesRange(from: startDate!, to: date)
            
            endDate = range.last
            
            for day in range {
                fsCalendar.select(day)
            }
            
            datesRange = range
            self.configureVisibleCells()
            return
        }
        
        if startDate != nil && endDate != nil {
            fsCalendar.selectedDates.forEach { date in
                fsCalendar.deselect(date)
            }
            
            startDate = nil
            endDate = nil
            datesRange = []
            
        }
        
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        
        if startDate != nil && endDate != nil {
            for day in fsCalendar.selectedDates {
                fsCalendar.deselect(day)
                
            }
            
            startDate = nil
            endDate = nil
            datesRange = []
        }
        
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    
    
    private func configureVisibleCells() {
        fsCalendar.visibleCells().forEach { cell in
            let date = fsCalendar.date(for: cell)
            let position = fsCalendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = cell as! DIYCalendarCell
        diyCell.circleImageView.isHighlighted = !self.gregorian.isDateInToday(date)
        if position == .current {
            var selectionType = SelectionType.none
            
            if fsCalendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if fsCalendar.selectedDates.contains(date) {
                    if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .range
                    } else if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(date) {
                        selectionType = .end
                    } else if fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .start
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
}

