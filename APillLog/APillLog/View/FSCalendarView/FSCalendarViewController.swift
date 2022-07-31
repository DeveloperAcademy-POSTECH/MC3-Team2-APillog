//
//  FSCalendarViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/30.
//
import UIKit
import FSCalendar
class FSCalendarViewController: UIViewController{
    
    // MARK: @IBOutlet
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var scrollBackgroundView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarHeaderView: UIView!
    
    
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    
    // MARK: View LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollBackgroundView.backgroundColor = UIColor.AColor.background
        self.backgroundView.backgroundColor = UIColor.AColor.background
        self.calendarHeaderView.backgroundColor = UIColor.AColor.white
        
        setUpEvents()
        
        dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: Date())
        sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: Date())
        detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: Date())
        
        setCalendarStyle()
        
        self.headerLabel.font = UIFont.AFont.calenderText
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCalendar()
        // 확인 필요
        calendarView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.calendarHeaderView.layoutIfNeeded()
        self.calendarHeaderView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        self.calendarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
    
    // MARK: @IBAction
    @IBAction func tapPrevButton(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
    }
    
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
            
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.headerHeight = 0
        calendarView.scope = .month
        headerLabel.text = self.dateFormatter.string(from: calendarView.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.headerLabel.text = self.dateFormatter.string(from: calendar.currentPage)
        
        dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: calendar.currentPage)
        sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: calendar.currentPage)
        detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: calendar.currentPage)
        
        calendarView.reloadData()
    }
    
    func setCalendarStyle() {
        self.calendarView.locale = Locale(identifier: "ko_KR")
        self.calendarView.appearance.weekdayFont = UIFont.AFont.calendarWeekDayFont
        
        calendarView.scrollEnabled = false
        calendarView.headerHeight = 0
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendarView.appearance.weekdayTextColor = UIColor.AColor.gray
        calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 0.8)
        
        calendarView.appearance.titleDefaultColor = UIColor.AColor.black
        
        calendarView.appearance.todayColor = UIColor.AColor.accent.withAlphaComponent(0.7)
        calendarView.appearance.selectionColor = UIColor.AColor.accent
    }
   
    
    var dosingPillEvents: [String] = []
    var sideEffectEvents: [String] = []
    var detailSideEffectEvents: [String] = []
    
    func setUpEvents() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
   

}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension FSCalendarViewController : FSCalendarDelegateAppearance {

    // MARK: - FSCalendarDelegateAppearance
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: date)
        var colorSet:[UIColor] = []
        if self.sideEffectEvents.contains(selectedDate) {
            colorSet.append(UIColor.blue)
        }
        
        if self.detailSideEffectEvents.contains(selectedDate){
            colorSet.append(UIColor.black)
        }
        
        if self.dosingPillEvents.contains(selectedDate){
            colorSet.append(UIColor.red)
        }
        return colorSet
    }
    
}

extension FSCalendarViewController : FSCalendarDataSource {

    // MARK: - FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: date)
        var count: Int = 0
        if self.sideEffectEvents.contains(selectedDate) {
            count += 1
        }
        
        if self.detailSideEffectEvents.contains(selectedDate){
            count += 1
        }
        
        if self.dosingPillEvents.contains(selectedDate){
            count += 1
        }
        
        return count
    }
}

extension FSCalendarViewController: FSCalendarDelegate{

    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
    }
}
