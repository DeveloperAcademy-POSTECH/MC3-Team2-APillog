//
//  CalendarMonth.swift
//  APillLog
//
//  Created by dohankim on 2022/08/11.
//

import UIKit

protocol CalendarMonthDelegate: AnyObject {
    func fetchDate(date: Date)
}
    class CalendarMonth: UIView {
        @IBOutlet weak var prevButton: UIButton!
        @IBOutlet weak var selectedDate: UILabel!
        @IBOutlet weak var nextButton: UIButton!

            
            weak var delegate: CalendarMonthDelegate?
            
            let datePicker: UIDatePicker = {
                
                let datePicker = UIDatePicker()
                datePicker.locale = .current
                datePicker.maximumDate = Date()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .inline
                
                datePicker.backgroundColor = UIColor.AColor.background
                datePicker.tintColor = UIColor.AColor.accent
                
                datePicker.layer.borderWidth = 0.2
                datePicker.layer.borderColor = UIColor.AColor.black.cgColor
                datePicker.layer.cornerRadius = 10
                datePicker.layer.masksToBounds = true
                
                datePicker.translatesAutoresizingMaskIntoConstraints = false
                datePicker.isHidden = true
                
                return datePicker
            }()
            
            var nextButtonState: Bool = true {
                didSet {
                    nextButton.isEnabled = nextButtonState
                    nextButton.tintColor = nextButtonState ? UIColor.AColor.black : UIColor.AColor.disable
                }
            }
            
            required init?(coder: NSCoder) {
                super.init(coder: coder)
                customInit()
                self.selectedDate.font = UIFont.AFont.navigationTitle
            }
            
            override init(frame: CGRect) {
                super.init(frame: frame)
            }

            private func customInit() {
                guard let view = Bundle.main.loadNibNamed("CalendarMonthView", owner: self, options: nil)?.first as? UIView else { return }
                    view.frame = self.bounds
                    self.addSubview(view)
                
                selectedDate.text = fetchSelectedDate(date: Date())
                selectedDate.isUserInteractionEnabled = true
                
                nextButtonState = false
                prevButton.tintColor = UIColor.AColor.black
            }
            
            // MARK: DatePicker func
            private func fetchSelectedDate(date: Date) -> String {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko")
                formatter.dateFormat = "yyyy년 MM월"
                self.delegate?.fetchDate(date: date)
                return formatter.string(from: date)
            }
            
            private func setDatePickerConstraints() {
                datePicker.translatesAutoresizingMaskIntoConstraints = false
                datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
                datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                datePicker.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 30).isActive = true
            }
            
            
            
            
            @objc private func datePickerValueChanged(sender: UIDatePicker) {
                setDateTitle(date: datePicker.date)
                self.datePicker.isHidden = true
            }
            
            // MARK: IBAction
            @IBAction func didTapPrevButton() {
                self.datePicker.date = Calendar.current.date(byAdding: .month, value: -1, to: datePicker.date)!
                setDateTitle(date: datePicker.date)
            }
            
            @IBAction func didTapNextButton() {
                self.datePicker.date = Calendar.current.date(byAdding: .month, value: 1, to: datePicker.date)!
                setDateTitle(date: datePicker.date)
            }
            
            func setDateTitle(date: Date) {
                self.delegate?.fetchDate(date: date)
                selectedDate.text = fetchSelectedDate(date: date)
                nextButtonState = !Calendar.current.isDateInToday(date)
                datePicker.isHidden = true
            }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


