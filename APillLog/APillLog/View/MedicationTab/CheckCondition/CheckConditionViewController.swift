//
//  CheckConditionViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/20.
//

import UIKit

class CheckConditionViewController: UIViewController, UITextViewDelegate {
    
    // MARK: 변수
    var pillSideEffect: String = ""
    var pillMedicinalEffect: String = ""
    var pillDetailContext: String = ""
    
    var pillSideEffectIsOn: Bool = false
    var pillMedicinalEffectIsOn: Bool = false
    var pillDetailContextIsOn: Bool = false
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
    
    override func viewDidDisappear(_ animated: Bool) {
        for (key, value) in pillSideEffectDummyData {
            if value == true {
                self.pillSideEffect += "\(key) "
            }
        }
        
        for (key, value) in pillMedicinalEffectDummyData {
            if value == true {
                self.pillMedicinalEffect += "\(key) "
            }
        }
        
        print(pillSideEffect)
        print(pillMedicinalEffect)
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
            if value == true {
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
            if value == true {
                self.pillMedicinalEffectIsOn = true
                break
            } else {
                self.pillMedicinalEffectIsOn = false
            }
        }
        
        // saveButtonState 값 체크
        if self.pillSideEffectIsOn || self.pillMedicinalEffectIsOn || self.pillDetailContextIsOn {
            self.saveButtonState = true
        } else {
            self.saveButtonState = false
        }
        
        self.changeButtonState(sender)
    }
    
    @IBAction func tapBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapConditionSaveButton(_ sender: Any) {
        // TODO: 버튼 눌렀을 때 값이 코어데이터로 저장되도록
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Init & Toggle ButtonState
    // ChipUI 의 State 변경 시 Style 변경 함수
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
    
    
    func textViewDidChange(_ textView: UITextView) {
        if detailContext.text.count > 150  {
            detailContext.deleteBackward()
        }
        
        if detailContext.text.count > 0 {
            self.pillDetailContextIsOn = true
        } else {
            self.pillDetailContextIsOn = false
        }
        
        if self.pillSideEffectIsOn || self.pillMedicinalEffectIsOn || self.pillDetailContextIsOn {
            self.saveButtonState = true
        } else {
            self.saveButtonState = false
        }
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
    
    @IBAction func tabBackgroundView(_ sender: Any) {
        view.endEditing(true)
    }
}

