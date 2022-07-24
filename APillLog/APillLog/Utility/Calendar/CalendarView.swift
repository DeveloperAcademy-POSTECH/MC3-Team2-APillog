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
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.backgroundColor = UIColor.AColor.white
        datePicker.tintColor = UIColor.AColor.accent
        
        datePicker.layer.borderWidth = 0.2
        datePicker.layer.borderColor = UIColor.AColor.black.cgColor
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
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
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        
        selectedDate.text = fetchSelectedDate(date: Date())
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
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 30).isActive = true
    }
    
    
    @objc private func labelClicked(_ tapRecognizer: UITapGestureRecognizer) {
        superview?.addSubview(datePicker)
        
        datePicker.layer.shadowColor = UIColor.black.cgColor
        datePicker.layer.shadowOffset = .zero
        datePicker.layer.shadowRadius = 10
        datePicker.layer.shadowOpacity = 0.9
        datePicker.isHidden.toggle()
        setDatePickerConstraints()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        setDateTitle(te: datePicker.date)
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
