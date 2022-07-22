//
//  CalendarView.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/20.
//

import UIKit

protocol CalendarViewDelegate: AnyObject {
    func fetchDate(date: Date)
}

class CalendarView: UIView {
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    weak var delegate: CalendarViewDelegate?
    
    let datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = UIColor.AColor.white
        datePicker.tintColor = UIColor.AColor.accent
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.maximumDate = Date()
        datePicker.isHidden = true
        return datePicker
    }()
    
    var nextButtonState: Bool = false {
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
        guard let view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as? UIView else { return }
            view.frame = self.bounds
            self.addSubview(view)
        
        selectedDate.text = fetchSelectedDate(date: Date())
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        selectedDate.addGestureRecognizer(gestureRecognize)
        selectedDate.isUserInteractionEnabled = true
        
        nextButtonState = false
        prevButton.tintColor = UIColor.AColor.black
    }
    
    // MARK: DatePicker func
    private func fetchSelectedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 E요일"
        self.delegate?.fetchDate(date: date)
        return formatter.string(from: date)
    }
    
    private func setDatePickerConstraints() {
        self.datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        self.datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc private func labelClicked(_ tapRecognizer: UITapGestureRecognizer) {
        
        superview!.addSubview(datePicker)
        datePicker.isHidden.toggle()
        setDatePickerConstraints()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.touchDown)
        datePicker.center = superview?.center ?? CGPoint(x: 0, y: 0)
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        setDateTitle(date: datePicker.date)
        self.datePicker.isHidden = true
    }
    
    // MARK: IBAction
    @IBAction func didTapPrevButton() {
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: -1, to: datePicker.date)!
        setDateTitle(date: datePicker.date)
    }
    
    @IBAction func didTapNextButton() {
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: datePicker.date)!
        setDateTitle(date: datePicker.date)
    }
    
    func setDateTitle(date: Date) {
        self.delegate?.fetchDate(date: date)
        selectedDate.text = fetchSelectedDate(date: date)
        nextButtonState = !Calendar.current.isDateInToday(date)
        datePicker.isHidden = true
    }
}


