//
//  AddShowPrimaryPillController.swift
//  APillLog
//
//  Created by 종건 on 2022/08/22.
//

import DropDown
import UIKit
import SwiftUI

class AddShowPrimaryPillController: UIViewController, UISheetPresentationControllerDelegate{

    @IBOutlet weak var primaryPillMorningButton: UIButton!
    @IBOutlet weak var primaryPillAfternoonButton: UIButton!
    @IBOutlet weak var primaryPillEveningButton: UIButton!
    
    @IBOutlet weak var PrimaryPillDosage: UITextField!
    
    @IBOutlet weak var savePrimaryPillButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var duplicateWarningLabel: UILabel!
    
    @IBOutlet weak var primaryPillDosageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var dropDownButton: UIButton!
    
    @IBOutlet weak var morningTimePicker: UIDatePicker!
    @IBOutlet weak var afternoonTimePicker: UIDatePicker!
    @IBOutlet weak var eveningTimePicker: UIDatePicker!
    
//    @IBOutlet weak var moringTitle: UILabel!
//    @IBOutlet weak var afternoonTitle: UILabel!
//    @IBOutlet weak var eveningTitle: UILabel!
    var selectedTime: Date = Date()
    
    // MARK: Property
    var primaryPillDosingCycle: Int = 0
    var primaryPillList: [PrimaryPill] = []
    var primaryPillDosageSegmentedTitle = "mg"
    
    var delegate: AddPrimaryPillViewControllerDelegate?
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    let primaryPillDropDown = DropDown()
    let primaryPillDropDownList = ["콘서타", "메디키넷", "메타데이트", "페로스핀", "페니드",  "환인아토목세틴", "스트라테라", "켐베이"]
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.detents = [.large()]
        savePrimaryPillButton.isEnabled = false
        primaryPillList = CoreDataManager.shared.fetchPrimaryPill()
        
        duplicateWarningLabel.font = UIFont.AFont.articleBody
        configureDropDown()
    }
    
    // MARK: @IBAction
    @IBAction func tapCancelButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
 
    @IBAction func tapSaveButton() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        let selectedDate = dateFormatter.string(from: selectedTime)
        
        if primaryPillMorningButton.isSelected {
            let pillName = dropDownTextField.text ?? ""
            let pillDosage = (PrimaryPillDosage.text ?? "") + primaryPillDosageSegmentedTitle
            CoreDataManager.shared.addShowPrimaryPill(id: UUID(), name: pillName, dosage: pillDosage, isTaking: false, cycle: Int16(1), selectDate: selectedDate, takeTime: Date())
            print("Debug -- selectButton")
        }
        if primaryPillAfternoonButton.isSelected {
            let pillName = dropDownTextField.text ?? ""
            let pillDosage = (PrimaryPillDosage.text ?? "") + primaryPillDosageSegmentedTitle
            CoreDataManager.shared.addShowPrimaryPill(id: UUID(), name: pillName, dosage: pillDosage, isTaking: false, cycle: Int16(2), selectDate: selectedDate, takeTime: Date())
        }
        if primaryPillEveningButton.isSelected {
            let pillName = dropDownTextField.text ?? ""
            let pillDosage = (PrimaryPillDosage.text ?? "") + primaryPillDosageSegmentedTitle
            CoreDataManager.shared.addShowPrimaryPill(id: UUID(), name: pillName, dosage: pillDosage, isTaking: false, cycle: Int16(4), selectDate: selectedDate, takeTime: Date())
        }
        
        delegate?.didAddPrimaryPill()
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func detectNameTextField(){
        detectEnableSaveButton()
    }
    
    @IBAction func detectDosageTextField(){
        detectEnableSaveButton()
    }
    
    @IBAction func clickTextFieldChangeBorder(_ sender: UITextField) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.AColor.textFieldBorder.cgColor
        sender.layer.cornerRadius = 5.0
        
//        checkDuplication()
    }
    
    @IBAction func clickTextFieldChangeBorderOn(_ sender: UITextField) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.AColor.accent.cgColor
        sender.layer.cornerRadius = 5.0
    }
    
    @IBAction func togglePrimaryPillMorning(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 1
        } else {
            self.primaryPillDosingCycle -= 1
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    @IBAction func togglePrimaryPillAfternoon(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 2
        } else {
            self.primaryPillDosingCycle -= 2
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    @IBAction func togglePrimaryPillEvening(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 4
        } else {
            self.primaryPillDosingCycle -= 4
        }
        changePrimaryPillDosingButtonState(sender)
        detectEnableSaveButton()
    }
    
    @IBAction func selectPrimaryPillDosage(_ sender: UISegmentedControl) {
        switch(primaryPillDosageSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillDosageSegmentedTitle = "mg"
            detectEnableSaveButton()
        case 1:
            primaryPillDosageSegmentedTitle = "정"
            detectEnableSaveButton()
        default:
            return
        }
    }
    
    @IBAction func tapDropDownButton(_ sender: UIButton) {
        primaryPillDropDown.show()
        self.dropDownImage.image = UIImage(systemName: "arrowtriangle.up.fill")
    }
    
    @IBAction func tapBackgroundView(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    // MARK: Function
    func configureDropDown() {
        dropDownView.backgroundColor = UIColor.AColor.white
        dropDownView.cornerRadius = 5.0
        
        DropDown.appearance().textColor = UIColor.AColor.black
        DropDown.appearance().selectedTextColor = UIColor.AColor.accent
        DropDown.appearance().backgroundColor = UIColor.AColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.AColor.background
        DropDown.appearance().setupCornerRadius(5.0)
        
        primaryPillDropDown.dismissMode = .automatic
        primaryPillDropDown.bottomOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        
        dropDownTextField.text = "약의 이름을 입력해주세요"
        dropDownTextField.textColor = UIColor.AColor.disable
//        dropDownTextField.layer.borderColor = UIColor.AColor.accent.cgColor
        dropDownImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        
        self.tapDropDownShow()
    }
    
    func tapDropDownShow() {
        primaryPillDropDown.dataSource = primaryPillDropDownList
        primaryPillDropDown.anchorView = self.dropDownView
        primaryPillDropDown.topOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        
        primaryPillDropDown.selectionAction = { [weak self] (item, index) in
            self?.dropDownTextField.text = self?.primaryPillDropDownList[item]
            self?.dropDownTextField.textColor = self?.dropDownTextField.text == "약의 이름을 입력해주세요" ? UIColor.AColor.disable : UIColor.AColor.black
            self?.dropDownImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            
        }
        
        primaryPillDropDown.cancelAction = { [weak self] in
            self?.dropDownImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        }
    }
    
    func changePrimaryPillDosingButtonState(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.AColor.accent
            button.setTitleColor(UIColor.AColor.white, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(UIColor.AColor.gray, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.textFieldBorder.cgColor
        }
    }
    
    func detectEnableSaveButton(){
        let pillName = dropDownTextField.text ?? ""
        let pillDosage = PrimaryPillDosage.text ?? ""
        
        if (pillName != "" && pillDosage != "" && primaryPillDosingCycle != 0)
        {
          //  savePrimaryPillButton.isEnabled = true
            checkDuplication()
        }
        else{
            savePrimaryPillButton.isEnabled = false
        }
    }
    
    func checkDuplication() {
        for pill in primaryPillList {
            if dropDownTextField.text == pill.name && ((PrimaryPillDosage.text ?? "") + primaryPillDosageSegmentedTitle == pill.dosage) {
                savePrimaryPillButton.isEnabled = false
                duplicateWarningLabel.isHidden = false
                return
            }
        }
        savePrimaryPillButton.isEnabled = true
        savePrimaryPillButton.tintColor = UIColor.AColor.accent
        duplicateWarningLabel.isHidden = true
    }
    func changeDateFormat(date: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        let calendarSelectedDate: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let currentTime: String = dateFormatter.string(from: Date())
        let takingTime = calendarSelectedDate + " " + currentTime
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: takingTime) ?? Date()
    }
}
