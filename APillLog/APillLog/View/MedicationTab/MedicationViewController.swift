//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit
import CoreData

class MedicationViewController: UIViewController {

    // MARK: - IBOutlets

    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill Field
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    @IBOutlet weak var takeAllPrimaryPillButton: UIButton!
    
    // Secondary Pill Field
    @IBOutlet weak var secondaryPillTableView: UITableView!
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!
    
    // MARK: - Properties
    var cellIdentifier = "medicationPillCell"
    var coredataManager: CoreDataManager = CoreDataManager()
    // primary pills
    // secondary pills
    var primaryPillDataMorning: [ShowPrimaryPill]? = []
    var primaryPillDataLunch: [ShowPrimaryPill]? = []
    var primaryPillDataDinner: [ShowPrimaryPill]? = []
    var secondaryPillData: [ShowSecondaryPill]? = []
    
    // MARK: - DummyData
    var primaryPillsDummyData = fetchPrimaryPillsDummyData()
    var secondaryPillsDummyData = fetchSecondaryPillsDummyData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var primaryPillData: [ShowPrimaryPill]? = coredataManager.fetchShowPrimaryPill(selectedDate: Date())
        primaryPillDataMorning = coredataManager.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillData)
        primaryPillDataLunch = coredataManager.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillData)
        primaryPillDataDinner = coredataManager.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillData)
        var secondaryPillData = coredataManager.fetchShowSecondaryPill(selectedDate: Date())
        
        
        setMedicationTableViews()
        setStyle()
    }
    
    private func setMedicationTableViews() {
        // Primary Pill TableView
        primaryPillTableView.delegate = self
        primaryPillTableView.dataSource = self
        
        // Secondary Pill TableView
        secondaryPillTableView.delegate = self
        secondaryPillTableView.dataSource = self
        
        // Cell register
        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        secondaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        
        // TableView Style
        primaryPillTableView.isScrollEnabled = false
        secondaryPillTableView.isScrollEnabled = false
    }
    
    private func setStyle(){
        self.view.backgroundColor = UIColor.AColor.background
//        setDatePickerStyle()
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }
    
//    private func setDatePickerStyle() {
//        // image
//        lastDayButton.setImage(UIImage(named: "left-black"), for: .normal)
//        nextDayButton.setImage(UIImage(named: "right-gray"), for: .normal)
//
//        // color
//        lastDayButton.tintColor = UIColor.AColor.black
//        nextDayButton.tintColor = UIColor.AColor.disable
//    }
    
    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }
    
    private func setPrimaryPillViewStyle() {
        primaryPillField.layer.cornerRadius = 10
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillField.layer.cornerRadius = 10
    }
    
    @IBAction func timeSegmentedControlSelected(_ sender: Any) {
        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillTableView.reloadData()
            break
        case 1:
            primaryPillTableView.reloadData()
        case 2:
            primaryPillTableView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func tapTakeAllPrimaryPillButton(_ sender: UIButton) {
        // TODO: - 모두 복용
    }
}

extension MedicationViewController: AddSecondaryPillViewControllerDelegate {

    // MARK: AddSecondaryPillViewControllerDelegate
    func didFinishModal(selectedPill: String) {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
    
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
}

// MARK: - Extensions
extension MedicationViewController: UITableViewDataSource {
    
    // 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == primaryPillTableView {
            switch timeSegmentedControl.selectedSegmentIndex {
                case 0:
                // test용
                return 3
//                return primaryPillDataMorning!.count
                case 1:
//                    return primaryPillDataLunch!.count
                // test용
                return 3
                case 2:
//                    return primaryPillDataDinner!.count
                // test용
                return 3
                default: break
            }
            return 0
        } else {
            return secondaryPillData!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MedicationPillCell

        // test용
        if tableView == primaryPillTableView {
            // Image
            cell.pillImageView.image = UIImage(named: "primaryPill")
            // Title
            cell.cellTitleLabel.text = primaryPillsDummyData[indexPath.row].name + " \(primaryPillsDummyData[indexPath.row].dosage)"
            // Time
            cell.pillTimeLabel.text = primaryPillsDummyData[indexPath.row].takeTime != "" ?
            primaryPillsDummyData[indexPath.row].takeTime + "에 먹었어요." : "아직 복약 전이에요"
            // Style
            cell.cellTitleLabel.font = UIFont.AFont.chipText
            cell.pillTimeLabel.font = UIFont.AFont.caption
        } else {
            // Image
            cell.pillImageView.image = UIImage(named: "secondaryPill")
            // Title
            cell.cellTitleLabel.text = secondaryPillsDummyData[indexPath.row].name + " \(secondaryPillsDummyData[indexPath.row].dosage)"
            // Time
            cell.pillTimeLabel.text = secondaryPillsDummyData[indexPath.row].takeTime != "" ?
            secondaryPillsDummyData[indexPath.row].takeTime + "에 먹었어요." :
            "아직 복약 전이에요"
            // Style
            cell.cellTitleLabel.font = UIFont.AFont.chipText
            cell.pillTimeLabel.font = UIFont.AFont.caption
        }
    return cell
    }
}
        
        // MARK: - CoreData 적용부
        // TODO: - Add 뷰들 연결 후 확인하면서 수정 필요
//        if tableView == primaryPillTableView {
//            // Image
//            cell.pillImageView.image = UIImage(named: "primaryPill")
//
//            // Style
//            cell.cellTitleLabel.font = UIFont.AFont.chipText
//            cell.pillTimeLabel.font = UIFont.AFont.caption
//
//            switch timeSegmentedControl.selectedSegmentIndex {
//            // 아침
//                case 0:
//                // Title
//                cell.cellTitleLabel.text = primaryPillDataMorning[indexPath.row].name + " \(primaryPillDataMorning[indexPath.row].dosage)"
//                // Time
//                cell.pillTimeLabel.text = primaryPillDataMorning[indexPath.row].takeTime != "" ?
//                primaryPillsDummyData[indexPath.row].takeTime + "에 먹었어요." : "아직 복약 전이에요"
//                return cell
//
//            // 점심
//                case 1:
//                cell.cellTitleLabel.text = primaryPillDataLunch[indexPath.row].name + " \(primaryPillDataLunch[indexPath.row].dosage)"
//                // Time
//                cell.pillTimeLabel.text = primaryPillDataLunch[indexPath.row].takeTime != "" ?
//                primaryPillDataLunch[indexPath.row].takeTime + "에 먹었어요." : "아직 복약 전이에요"
//                return cell
//
//            // 저녁
//                case 2:
//                cell.cellTitleLabel.text = primaryPillDataDinner[indexPath.row].name + " \(primaryPillDataDinner[indexPath.row].dosage)"
//                // Time
//                cell.pillTimeLabel.text = primaryPillDataDinner[indexPath.row].takeTime != "" ?
//                primaryPillDataDinner[indexPath.row].takeTime + "에 먹었어요." : "아직 복약 전이에요"
//                return cell
//
//                default: break
//                return cell
//            } else {
//                cell.cellTitleLabel.text = primaryPillDataLunch[indexPath.row].name + " \(primaryPillDataLunch[indexPath.row].dosage)"
//                // Time
//                cell.pillTimeLabel.text = primaryPillDataLunch[indexPath.row].takeTime != "" ?
//                primaryPillDataLunch[indexPath.row].takeTime + "에 먹었어요." : "아직 복약 전이에요"
//                return cell
//            }
//        }
        

extension MedicationViewController: UITableViewDelegate {

}

// MARK: - Test
/*
 cycle 예시
 아침 == 100 => 4
 점심 == 010 => 2
 저녁 == 001 => 1
 아침, 점심 = 110 => 6
 점심, 저녁 = 011 => 3
 아침, 저녁 = 101 => 5
 아침, 점심, 저녁 => 111 => 7
 
 아침 : 4, 5, 6, 7
 점심 : 2, 3, 6, 7
 저녁 : 1, 3, 5, 7
*/

private func fetchPrimaryPillsDummyData() -> [PrimaryPillModel] {
    [
        PrimaryPillModel(
            name: "콘서타A",
            dosage: "18mg",
            cycle: 6,
            isTaking: false,
            takeTime: "08:00",
            selectDate: "2022-07-21",
            id: UUID()
        ),
        PrimaryPillModel(
            name: "콘서타B",
            dosage: "18mg",
            cycle: 4,
            isTaking: false,
            takeTime: "",
            selectDate: "2022-07-21",
            id: UUID()
        ),
        PrimaryPillModel(
            name: "콘서타C",
            dosage: "18mg",
            cycle: 4,
            isTaking: false,
            takeTime: "",
            selectDate: "2022-07-21",
            id: UUID()
        )
    ]
}

private func fetchSecondaryPillsDummyData() -> [SecondaryPillModel] {
    [
        SecondaryPillModel(
            name: "타이레놀",
            dosage: "1정",
            isTaking: false,
            takeTime: "08:00",
            selectDate: "2022-07-21",
            id: UUID()
        ),
        SecondaryPillModel(
            name: "인데놀정",
            dosage: "10mg",
            isTaking: false,
            takeTime: "",
            selectDate: "2022-07-21",
            id: UUID()
        )
    ]
}
