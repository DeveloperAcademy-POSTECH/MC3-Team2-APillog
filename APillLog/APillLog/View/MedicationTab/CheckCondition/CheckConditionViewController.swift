//
//  CheckConditionViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/20.
//

import UIKit

class CheckConditionViewController: UIViewController {
    
    // MARK: 변수
    // 증상 반환
    var pillSideEffect: [String] = []
    var pillDetailContext: String = ""
    
    // 증상 저장 버튼 활성화를 위한 변수
    var pillSideEffectIsOn: Bool = false
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
    var pillDisadvantage: [String: Bool] = ["불면" : false, "불안" : false, "두통" : false, "두근거림" : false, "어지러움" : false, "식욕 감소" : false, "입안 건조" : false, "구역" : false, "땀 과다증" : false, "과민성" : false]
        
    // MARK: @IBOutlet
    @IBOutlet weak var detailContext: UITextView!
    @IBOutlet weak var conditionBackgroundView: UIView!
    @IBOutlet weak var conditionViewNavigationBar: UINavigationBar!
    @IBOutlet weak var conditionSaveButton: UIButton!
    @IBOutlet weak var countDetailContext: UILabel!
    
    @IBOutlet weak var textViewTitle: UILabel!
    @IBOutlet weak var chipTitle: UILabel!
    
    // MARK: View LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailContext.delegate = self
        
        setStyle()
        
        pillSideEffectDummyData = self.pillDisadvantage
    }
    
    
    // MARK: Style Function
    private func setStyle() {
        self.view.backgroundColor = UIColor.AColor.background
        setDetailContextStyle()
        setConditionBackgroundViewStyle()
        setConditionViewNavigationBarStyle()
        setConditionSaveButtonStyle()
        setBackButtonStyle()
        setSectionTitleStyle()
    }
    
    private func setBackButtonStyle() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: UIColor.AColor.accent)), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        button.setTitle("뒤로", for: .normal)
        button.setTitleColor(UIColor.AColor.accent, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        
        self.conditionViewNavigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setSectionTitleStyle() {
        self.textViewTitle.font = UIFont.AFont.checkConditionViewSectionTitle
        self.chipTitle.font = UIFont.AFont.checkConditionViewSectionTitle
    }
    
    private func setDetailContextStyle() {
        self.detailContext.layer.borderWidth = 1.0
        self.detailContext.layer.borderColor = UIColor.AColor.gray.cgColor
        self.detailContext.layer.cornerRadius = 10
        self.detailContext.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        self.conditionSaveButton.layer.cornerRadius = 10
        self.conditionSaveButton.titleLabel?.font = UIFont.AFont.buttonTitle
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
        
        self.checkSaveButtonState()
        
        self.changeButtonState(sender)
    }
    
    @objc func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapConditionSaveButton(_ sender: Any) {
        // 부작용 저장
        for (key, value) in pillSideEffectDummyData {
            if value {
                self.pillSideEffect.append("\(key)")
            }
        }
        
        // 상세 설명 저장
        self.pillDetailContext = self.detailContext.text
        
        CoreDataManager.shared.recordHistoryAndRecordCondition(name: nil, dosage: nil, sideEffect: self.pillSideEffect, medicinalEffect: nil, detailContext: self.pillDetailContext , takingTime: Date())
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: function
    // ChipUI 의 State 에 따른 Style 변경 함수
    func changeButtonState(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.AColor.accent
            button.setTitleColor(UIColor.AColor.white, for: .selected)
            button.titleLabel?.font = UIFont.AFont.chipText
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.white.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(UIColor.AColor.gray, for: .normal)
            button.titleLabel?.font = UIFont.AFont.chipText
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
    
    // conditionSaveButton 의 State 를 확인하는 함수
    func checkSaveButtonState() {
        if self.pillSideEffectIsOn || self.pillDetailContextIsOn {
            self.saveButtonState = true
        } else {
            self.saveButtonState = false
        }
    }
    
}

// MARK: TextView Function
extension CheckConditionViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if detailContext.text.count > 0 {
            self.pillDetailContextIsOn = true
        } else {
            self.pillDetailContextIsOn = false
        }
        self.checkSaveButtonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentDetailContext = textView.text ?? ""
        guard let stringRange = Range(range, in: currentDetailContext) else { return false }
        
        let changedText = currentDetailContext.replacingCharacters(in: stringRange, with: text)
        
        countDetailContext.text = "(\(changedText.count)/30)"
        
        countDetailContext.textColor = changedText.count == 30 ? UIColor.red : UIColor.AColor.gray
        
        return changedText.count <= 29
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
            _ = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
                self.conditionBackgroundView.transform = CGAffineTransform(translationX: 0, y: -50)
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

