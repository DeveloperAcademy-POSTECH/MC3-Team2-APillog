//
//  CheckConditionViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/20.
//

import UIKit

class CheckConditionViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailContext.delegate = self
        setStyle()
    }
    
    // MARK: @IBOutlet
    @IBOutlet weak var detailContext: UITextView!
    
    @IBOutlet weak var conditionBackgroundView: UIView!
    
    @IBOutlet weak var conditionViewNavigationBar: UINavigationBar!
    
    
    // MARK: Style Function
    private func setStyle() {
        self.view.backgroundColor = UIColor.AColor.background
        setDetailContextStyle()
        setConditionBackgroundViewStyle()
        setConditionViewNavigationBarStyle()
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
    
    // MARK: @IBAction
    @IBAction func toggleSideEffectButtonState(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.changeButtonState(sender)
    }
    
    @IBAction func toggleMedicinalEffectButtonState(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.changeButtonState(sender)
    }
    
    @IBAction func tapBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Init & Toggle ButtonState
    func initConditionButton(_ button: UIButton){
        button.setTitleColor(UIColor.AColor.gray, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.AColor.disable.cgColor
        button.layer.cornerRadius = button.frame.height / 2
    }
    
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

