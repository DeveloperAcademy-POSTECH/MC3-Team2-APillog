//
//  FSCalendarViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/30.
//
import UIKit
import FSCalendar
class FSCalendarViewController: UIViewController{
    
    @IBOutlet weak var calendar: FSCalendar!
    var dosingPillEvents: [String] = []
    var sideEffectEvents: [String] = []
    var detailSideEffectEvents: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        setUpEvents()
//        if let selectedDate = calendar.selectedDate{
//            dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: selectedDate)
//            sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: selectedDate)
//            detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: selectedDate)
//        }
//        else{
            dosingPillEvents = CoreDataManager.shared.fetchMonthDosingPillDate(date: Date())
            print("debut-----",dosingPillEvents)
            sideEffectEvents = CoreDataManager.shared.fetchMonthSideEffectDate(date: Date())
            detailSideEffectEvents = CoreDataManager.shared.fetchMotnDetailSideEffectDate(date: Date())
//        }
    }
    
    func setUpEvents() {
        calendar.delegate = self
        calendar.dataSource = self
    }
    
   

}
extension FSCalendarViewController : FSCalendarDelegateAppearance {

// MARK: - FSCalendarDelegateAppearance

func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
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
    dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
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




//extension FSCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
//    //이벤트 표시 개수
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if self.events.contains(date) {
//            return 1
//        } else {
//            return 0
//        }
//    }
//}
