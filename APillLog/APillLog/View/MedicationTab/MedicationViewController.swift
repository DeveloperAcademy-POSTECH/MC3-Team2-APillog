//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController, AddSecondaryPillViewControllerDelegate {

    // MARK: - IBOutlets

    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    
    // Secondary Pill
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    private func setStyle(){
        self.view.backgroundColor = .systemGray6
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }
    
    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }
    
    private func setPrimaryPillViewStyle() {
        primaryPillField.layer.cornerRadius = 10
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillField.layer.cornerRadius = 10
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
