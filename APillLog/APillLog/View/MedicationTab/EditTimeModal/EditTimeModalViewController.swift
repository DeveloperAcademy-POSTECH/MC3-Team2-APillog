//
//  EditTimeModalViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/08/14.
//

import UIKit

protocol EditTimeViewToMedicationViewDelegate {
    func didTimeChanged(isPrimary: Bool)
}

class EditTimeModalViewController: UIViewController, MedicationViewToEditTimeViewDelegate {

    var editTimeModalViewPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }

    // MARK: IBOutlets
    @IBOutlet weak var pillImage: UIImageView?
    @IBOutlet weak var pillName: UILabel?
    @IBOutlet weak var editTimePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    // MARK: Properties
    var delegate: EditTimeViewToMedicationViewDelegate?
    var oldTime = Date()
    var newTime = Date()
    var isPrimary = true
    var nowPrimaryPill = ShowPrimaryPill()
    var nowSecondaryPill = ShowSecondaryPill()

    override func viewDidLoad() {
        super.viewDidLoad()
        setEditTimeModalView()
        setEditTimePicker()
        detectEnableSaveButton()
    }

    // MARK: Functions
    func configure(pill: ShowPrimaryPill) {
        isPrimary = true
        nowPrimaryPill = pill
        guard let name = pill.name else { return }
        guard let time = pill.takeTime else { return }
        guard let dosage = pill.dosage else { return }
        DispatchQueue.main.async {
            self.pillName?.text = name + " " + dosage
            self.editTimePicker.date = time
            self.pillImage?.image = UIImage(named: "primaryPill")
            self.oldTime = time
        }
    }
    func configure(pill: ShowSecondaryPill) {
        isPrimary = false
        nowSecondaryPill = pill
        guard let name = pill.name else { return }
        guard let time = pill.takeTime else { return }
        guard let dosage = pill.dosage else { return }
        DispatchQueue.main.async {
            self.pillName?.text = name + " " + dosage
            self.editTimePicker.date = time
            self.pillImage?.image = UIImage(named: "secondaryPill")
            self.oldTime = time
        }
    }

    func setEditTimeModalView() {
        // modal
        modalPresentationStyle = .custom
        editTimeModalViewPresentationController.delegate = self
        editTimeModalViewPresentationController.selectedDetentIdentifier = .large
        editTimeModalViewPresentationController.prefersGrabberVisible = true
        editTimeModalViewPresentationController.detents = [.medium()]
        cancelButton.tintColor = UIColor.AColor.accent
        saveButton.tintColor = UIColor.AColor.accent
        
        // style
        pillName?.font = UIFont.AFont.cardViewTitle
    }

    func setEditTimePicker() {
        editTimePicker.datePickerMode = .time
        editTimePicker.preferredDatePickerStyle = .wheels
        editTimePicker.locale = Locale(identifier: "ko_KR")
        editTimePicker.addTarget(self, action: #selector(newTimeSelected), for: .valueChanged)
    }

    @objc
    func newTimeSelected(){
        newTime = editTimePicker.date
        detectEnableSaveButton()
    }

    // MARK: IBACtions
    @IBAction func tapCancelButton() {
        self.presentingViewController?.dismiss(animated: true)
    }

    @IBAction func tapSaveButton(_ sender: Any) {
        if isPrimary {
            CoreDataManager.shared.updateShowPillTakeTime(showPrimaryPill: nowPrimaryPill, takingTime: newTime)
        } else {
            CoreDataManager.shared.updateShowPillTakeTime(showSecondaryPill: nowSecondaryPill, takingTime: newTime)
        }
        self.delegate?.didTimeChanged(isPrimary: isPrimary)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    private func detectEnableSaveButton(){
        if oldTime == editTimePicker.date {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

extension EditTimeModalViewController: UISheetPresentationControllerDelegate {
}
