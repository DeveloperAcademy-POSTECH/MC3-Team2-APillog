//
//  CalendarView.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/20.
//

import UIKit

class CalendarView: UIView {
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var naxtDayButton: UIButton!
    
    let datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .systemBackground
        datePicker.tintColor = .systemGreen
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func commonInit() {
        let view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        naxtDayButton.isEnabled = false
    }
    
    func customInit() {
        
        guard let view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as? UIView else { return }
            view.frame = self.bounds
            self.addSubview(view)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 E요일"
        selectedDate.text = formatter.string(from: date)
        
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        selectedDate.addGestureRecognizer(gestureRecognize)
        selectedDate.isUserInteractionEnabled = true
    }
    
    // MARK: DatePicker func
    func setDatePickerConstraints() {
        self.datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        self.datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc private func labelClicked(_ tapRecognizer: UITapGestureRecognizer) {
        
        print("Hello \(datePicker.date)")
        superview!.addSubview(datePicker)
        self.datePicker.isHidden = false
        setDatePickerConstraints()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.center = superview!.center
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM월 dd일 E요일"
        selectedDate.text = formatter.string(from: sender.date)
        self.datePicker.isHidden = true
    }
//
//    @objc private func selectedDateChaged(sender: UILabel) {
//
//    }
    
    // MARK: IBAction
    @IBAction func tappedPrevButton() {
        self.datePicker.date = datePicker.date
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: -1, to: datePicker.date)!
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM월 dd일 E요일"
        selectedDate.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func tappedNextButton() {
        self.datePicker.date = datePicker.date
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: datePicker.date)!
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM월 dd일 E요일"
        selectedDate.text = formatter.string(from: datePicker.date)
    }
}


