//
//  EditTimeModalViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/08/14.
//

import UIKit

protocol EditTimeViewToMedicationViewDelegate {
    func didTimeChanged(newTime newTime: Date)
}
class EditTimeModalViewController: UIViewController, MedicationViewToEditTimeViewDelegate {

    var editTimeModalViewPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }

    // MARK: IBOutlets
    @IBOutlet weak var pillImage: UIImageView!
    @IBOutlet weak var pillName: UILabel?
    @IBOutlet weak var editTimePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Properties
    private var date = Date()
    var pill: ShowPrimaryPill = ShowPrimaryPill()
    var primaryPillList: [ShowPrimaryPill] = []
    var primaryPillListMorning: [ShowPrimaryPill] = []
    var primaryPillListLunch: [ShowPrimaryPill] = []
    var primaryPillListDinner: [ShowPrimaryPill] = []
    var primaryPillListDataSource: [ShowPrimaryPill] = []
    var delegate: EditTimeViewToMedicationViewDelegate?
    var newTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setEditTimeModalView()
        setEditTimePicker()
    }

    // MARK: Functions
    func configure(pill: ShowPrimaryPill) {
        self.pill = pill
        pillName?.text = pill.name
    }

    func setEditTimeModalView() {
        editTimeModalViewPresentationController.delegate = self
        editTimeModalViewPresentationController.selectedDetentIdentifier = .large
        editTimeModalViewPresentationController.prefersGrabberVisible = true
        editTimeModalViewPresentationController.detents = [.medium()]
    }

    func setEditTimePicker() {
//        editTimePicker.locale = .current
        editTimePicker.datePickerMode = .time
        editTimePicker.preferredDatePickerStyle = .inline
        editTimePicker.locale = Locale(identifier: "ko_KR")
        editTimePicker.addTarget(self, action: #selector(newTimeSelected), for: .valueChanged)
    }
    
    @objc
    func newTimeSelected(){
        print(editTimePicker.date)
        newTime = editTimePicker.date
    }
    
    // MARK: IBACtions
    @IBAction func tapCancelButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        self.delegate?.didTimeChanged(newTime: Date())
        self.presentingViewController?.dismiss(animated: true)
    }

}

extension EditTimeModalViewController: UISheetPresentationControllerDelegate {
    
}
