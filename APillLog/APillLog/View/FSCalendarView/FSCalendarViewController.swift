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
    var events: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        setUpEvents()
    }
    
    func setUpEvents() {
        calendar.delegate = self
        calendar.dataSource = self
      
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let xmas = formatter.date(from: "2022-7-25")
        let sampledate = formatter.date(from: "2022-07-22")
        events = [xmas!, sampledate!]
    }

}
extension FSCalendarViewController : FSCalendarDelegateAppearance {

// MARK: - FSCalendarDelegateAppearance

func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {

    if self.events.contains(date) {
        return [UIColor.blue]
    }
    return [UIColor.white]
}
}

extension FSCalendarViewController : FSCalendarDataSource {

// MARK: - FSCalendarDataSource

func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

      if self.events.contains(date) {
        return 1
      }
      return 0
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
