//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController, AddSecondaryPillViewControllerDelegate {

    // MARK: - IBOutlets
    // DatePicker
    @IBOutlet weak var lastDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!

    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillView: UIView!
    
    // Secondary Pill
    @IBOutlet weak var secondaryPillView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    private func setStyle(){
        self.view.backgroundColor = .systemGray6
        setDatePickerStyle()
//        setSymptomButtonStyle()
//        setPrimaryPillViewStyle()
//        setSecondaryPillViewStyle()
    }
    
    private func setDatePickerStyle() {
        // image
        lastDayButton.setImage(UIImage(named: "left-black"), for: .normal)
        nextDayButton.setImage(UIImage(named: "right-gray"), for: .normal)
        // color
        lastDayButton.tintColor = .darkGray
        nextDayButton.tintColor = .darkGray
    }
    
    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }
    
    private func setPrimaryPillViewStyle() {
        primaryPillView.layer.cornerRadius = 10
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillView.layer.cornerRadius = 10
    }
    
    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    
    // MARK: AddSecondaryPillViewControllerDelegate
    func didFinishModal(selectedPill: String) {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
        
    }
}
