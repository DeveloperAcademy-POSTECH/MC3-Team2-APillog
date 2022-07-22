//
//  CheckConditionViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/20.
//

import UIKit

class CheckConditionViewController: UIViewController, UITextViewDelegate {
    
    // MARK: 변수
    // 증상 반환
    var pillSideEffect: [String] = []
    var pillMedicinalEffect: [String] = []
    var pillDetailContext: String = ""
    
    // 증상 저장 버튼 활성화를 위한 변수
    var pillSideEffectIsOn: Bool = false
    var pillMedicinalEffectIsOn: Bool = false
    var pillDetailContextIsOn: Bool = false
    
    // 증상 저장 버튼 상태
    var saveButtonState: Bool = false {
        didSet {
            if saveButtonState {
                self.conditionSaveButton.isEnabled = true
                conditionSaveButtonStateStyle(self.conditionSaveButton)
            } else {
                self.conditionSaveButton.isEnabled = false
                conditionSaveButtonStateStyle(self.conditionSaveButton)
            }
        }
    }
    
    var pillSideEffectDummyData: [String : Bool]!
    var pillMedicinalEffectDummyData: [String: Bool]!
    
    var coreDataManager: CoreDataManager = CoreDataManager()
    
    // MARK: @IBOutlet
    @IBOutlet weak var detailContext: UITextView!
    @IBOutlet weak var conditionBackgroundView: UIView!
    @IBOutlet weak var conditionViewNavigationBar: UINavigationBar!
    @IBOutlet weak var conditionSaveButton: UIButton!
    
    // MARK: View LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailContext.delegate = self
        
        setStyle()
        
        pillSideEffectDummyData = PillData.pillData[0].pillDisadvantage
        pillMedicinalEffectDummyData = PillData.pillData[0].pillAdvantage
    }
    
    
    // MARK: Style Function
    private func setStyle() {
        self.view.backgroundColor = UIColor.AColor.background
        setDetailContextStyle()
        setConditionBackgroundViewStyle()
        setConditionViewNavigationBarStyle()
        setConditionSaveButtonStyle()
    }
    
    private func setDetailContextStyle() {
        self.detailContext.layer.borderWidth = 1.0
        self.detailContext.layer.borderColor = UIColor.AColor.gray.cgColor
        self.detailContext.layer.cornerRadius = 10
    }
    
    private func setConditionBackgroundViewStyle() {
        self.conditionBackgroundView.layer.cornerRadius = 10
    }
    
    private func setConditionViewNavigationBarStyle() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.AColor.background
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
        self.conditionViewNavigationBar.topItem?.title = "증상 입력"
    }
    
    private func setConditionSaveButtonStyle() {
        self.conditionSaveButtonStateStyle(self.conditionSaveButton)
    }
    
    // MARK: @IBAction
    @IBAction func toggleSideEffectButtonState(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.pillSideEffectDummyData["\(sender.titleLabel?.text ?? "")"] = true
            
        } else {
            self.pillSideEffectDummyData["\(sender.titleLabel?.text ?? "")"] = false
        }
        
        for (_, value) in pillSideEffectDummyData {
            if value {
                self.pillSideEffectIsOn = true
                break
            } else {
                self.pillSideEffectIsOn = false
            }
        }
        
        // saveButtonState 값 체크
        if self.pillSideEffectIsOn || self.pillMedicinalEffectIsOn || self.pillDetailContextIsOn {
            self.saveButtonState = true
        } else {
            self.saveButtonState = false
        }
        
        self.checkSaveButtonState()
        
        self.changeButtonState(sender)
    }
    
    @IBAction func toggleMedicinalEffectButtonState(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.pillMedicinalEffectDummyData["\(sender.titleLabel?.text ?? "")"] = true
        } else {
            self.pillMedicinalEffectDummyData["\(sender.titleLabel?.text ?? "")"] = false
        }
        
        for (_, value) in pillMedicinalEffectDummyData {
            if value {
                self.pillMedicinalEffectIsOn = true
                break
            } else {
                self.pillMedicinalEffectIsOn = false
            }
        }
        
        self.checkSaveButtonState()
        
        self.changeButtonState(sender)
    }
    
    @IBAction func tapBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapConditionSaveButton(_ sender: Any) {
        // 부작용 저장
        for (key, value) in pillSideEffectDummyData {
            if value {
                self.pillSideEffect.append("\(key)")
            }
        }
        
        // 약 효능 저장
        for (key, value) in pillMedicinalEffectDummyData {
            if value {
                self.pillMedicinalEffect.append("\(key)")
            }
        }
        // 상세 설명 저장
        self.pillDetailContext = self.detailContext.text
        
        coreDataManager.recordHistoryAndRecordCondition(name: [PillData.pillData[0].pillName], dosage: [PillData.pillData[0].pillDosage], sideEffect: self.pillSideEffect, medicinalEffect: self.pillMedicinalEffect, detailContext: self.pillDetailContext)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: function
    // ChipUI 의 State 에 따른 Style 변경 함수
    func changeButtonState(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.AColor.accent
            button.setTitleColor(UIColor.AColor.white, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(UIColor.AColor.gray, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.disable.cgColor
        }
    }
    
    // conditionSaveButton 의 State 에 따른 Style 변경 함수
    func conditionSaveButtonStateStyle(_ button: UIButton) {
        if button.isEnabled {
            button.backgroundColor = UIColor.AColor.accent
            button.setTitleColor(UIColor.AColor.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.white.cgColor
        } else {
            button.backgroundColor = UIColor.AColor.disable
            button.setTitleColor(UIColor.AColor.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.disable.cgColor
        }
    }
    
    func checkSaveButtonState() {
        if self.pillSideEffectIsOn || self.pillMedicinalEffectIsOn || self.pillDetailContextIsOn {
            self.saveButtonState = true
        } else {
            self.saveButtonState = false
        }
    }
    
    // TextView Function
    func textViewDidChange(_ textView: UITextView) {
        if detailContext.text.count > 0 {
            self.pillDetailContextIsOn = true
        } else {
            self.pillDetailContextIsOn = false
        }
        self.checkSaveButtonState()
    }
}

// MARK: TextView 선택 시 올라가는 conditionBackgroundView
extension CheckConditionViewController {
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
                self.conditionBackgroundView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            })
        }
    }
    
    @objc func keyboardDown() {
        self.conditionBackgroundView.transform = .identity
    }
    
    // keyboard 이외 View 터치시 Editing End
    @IBAction func tabBackgroundView(_ sender: Any) {
        view.endEditing(true)
    }
}

