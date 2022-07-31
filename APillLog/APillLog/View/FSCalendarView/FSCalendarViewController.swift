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
    
    private lazy var headerDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }()
    
    var dosingPillEvents: [String] = []
    var sideEffectEvents: [String] = []
    var detailSideEffectEvents: [String] = []
    
    let calendarDotDateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    // History 변수
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var guideLabel: UILabel!
    
    var historyData = [History]()
    var selectedDate: Date = Date()
    
    var guideLabelHidden = true {
        didSet {
            guideLabel.isHidden = guideLabelHidden
        }
    }
    
    var tableViewCellHeight: Int = 0
    
    func setUITableDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: Date())
    }
    
    
    private func resizingTableViewHeight(dataCount count: Double) {
        if count == 0 {
            tableViewHeight.constant = 66.0
        } else {
            tableViewHeight.constant = 91.0 * CGFloat(count)
        }
        
        backgroundViewHeight.constant = CGFloat(tableViewHeight.constant) + 500
    }
    
    func calculateTableViewCellHeight(_ date: Date) -> Double {
        let historyArray = CoreDataManager.shared.fetchHistory(selectedDate: date)
        var result: Double = 0
        
        for cell in historyArray {
            if cell.pillName == nil || cell.pillName == "" {
                
            } else {
                result += 1.0
            }
            if cell.sideEffect == nil || cell.sideEffect == [] {
                
            } else {
                result += 1.0
            }
            if cell.detailContext == nil || cell.detailContext == "" {
                
            } else {
                result += 0.8
            }
        }
        return result
    }
    
    // MARK: View LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollBackgroundView.backgroundColor = UIColor.AColor.background
        self.backgroundView.backgroundColor = UIColor.AColor.background
        self.calendarHeaderView.backgroundColor = UIColor.AColor.white
        
        self.guideLabel.font = UIFont.AFont.noHistory
        
        // delegation, datasource 할당
        setUpEvents()
        
        dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: Date())
        sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: Date())
        detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: Date())
        
        setCalendarStyle()
        
        self.headerLabel.font = UIFont.AFont.calenderText
        
        // History
        setUITableDelegate()
        registerNib()
        self.tableView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCalendar()
        
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: Date())
        tableView.reloadData()
        
        let cellCount = calculateTableViewCellHeight(Date())
        resizingTableViewHeight(dataCount: cellCount)
        
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
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
    
    func setUpEvents() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
            
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func setCalendar() {
        calendarView.scope = .month
        headerLabel.text = self.headerDateFormatter.string(from: calendarView.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.headerLabel.text = self.headerDateFormatter.string(from: calendar.currentPage)
        
        dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: calendar.currentPage)
        sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: calendar.currentPage)
        detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: calendar.currentPage)
        
        calendarView.reloadData()
    }
    
    // Calendar Style
    func setCalendarStyle() {
        calendarView.appearance.weekdayFont = UIFont.AFont.calendarWeekDayFont
        
        calendarView.scrollEnabled = false
        calendarView.headerHeight = 0
        
        calendarView.appearance.weekdayTextColor = UIColor.AColor.gray
        calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 0.8)
        
        calendarView.appearance.titleDefaultColor = UIColor.AColor.black
        
        calendarView.appearance.todayColor = UIColor.AColor.accent.withAlphaComponent(0.5)
        calendarView.appearance.selectionColor = UIColor.AColor.accent
        
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "SUN"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "MON"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "TUE"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "WED"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "THU"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "FRI"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "SAT"
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
        let selectedDate: String = calendarDotDateFormatter.string(from: date)
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
        
        let selectedDate: String = calendarDotDateFormatter.string(from: date)
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
        
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: date)
        tableView.reloadData()
        
        // tableView Height
        let totalCellCount = calculateTableViewCellHeight(date)
        resizingTableViewHeight(dataCount: totalCellCount)
        
        if historyData.count == 0 { guideLabelHidden = false }
        else { guideLabelHidden = true }
        
    }
    
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
    }
}

extension FSCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerNib() {
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "historyTableViewCell")
    }
    
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
            self.tableViewCellHeight += 1
        }
        if cell.sideEffect.text == nil || cell.sideEffect.text == "" {
            cell.stackViewSideEffect.isHidden = true
            cell.sideEffectLabelView.isHidden = true
        } else {
            cell.stackViewSideEffect.isHidden = false
            cell.sideEffectLabelView.isHidden = false
            self.tableViewCellHeight += 1
        }
        if cell.detailContext.text == nil || cell.detailContext.text == "" {
            cell.stackViewDetailContext.isHidden = true
            cell.detailContextLabelView.isHidden = true
        } else {
            cell.stackViewDetailContext.isHidden = false
            cell.detailContextLabelView.isHidden = false
            self.tableViewCellHeight += 1
        }
        
        return cell
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
