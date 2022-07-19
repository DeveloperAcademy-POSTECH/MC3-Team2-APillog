//
//  AddPrimaryPillViewController.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/18.
//

import UIKit

class AddPrimaryPillViewController: UIViewController, UISheetPresentationControllerDelegate {

    // MARK: @IBOutlet
    @IBOutlet weak var primaryPillMorningButton: UIButton!
    @IBOutlet weak var primaryPillAfternoonButton: UIButton!
    @IBOutlet weak var primaryPillEveningButton: UIButton!
    
    
    // MARK: Property
    var primaryPillDosingCycle: Int = 0
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.detents = [.medium()]
    }
    
    // MARK: @IBAction
    @IBAction func tabCancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func tabSaveButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func primaryPillMorning(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 1
        } else {
            self.primaryPillDosingCycle -= 1
        }
        changePrimaryPillDosingButtonState(sender)
    }
    
    @IBAction func primaryPillAfternoon(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 2
        } else {
            self.primaryPillDosingCycle -= 2
        }
        changePrimaryPillDosingButtonState(sender)
    }
    
    @IBAction func primaryPillEvening(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.primaryPillDosingCycle += 4
        } else {
            self.primaryPillDosingCycle -= 4
        }
        changePrimaryPillDosingButtonState(sender)
    }
    
    
    // MARK: Function
    func changePrimaryPillDosingButtonState(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor(red: 108/255, green: 199/255, blue: 90/255, alpha: 1)
            button.setTitleColor(.white, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1), for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        }
    }
}
