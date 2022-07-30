//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController {

    // MARK: - Properties
    let cellIdentifier = "medicationPillCell"

    // Primary Pill
    var primaryPillList: [ShowPrimaryPill] = []
    var primaryPillListMorning: [ShowPrimaryPill] = []
    var primaryPillListLunch: [ShowPrimaryPill] = []
    var primaryPillListDinner: [ShowPrimaryPill] = []
    var primaryPillListDataSource: [ShowPrimaryPill] = []

    // Secondary Pill
    var secondaryPillList: [ShowSecondaryPill] = []

    private var date = Date()

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()

    // MARK: - IBOutlets
    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!

    // Primary Pill
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var primaryPillViewLinkLabel: UILabel!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryPillFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var takingAllPrimaryPillsButton: UIButton!

    // Secondary Pill
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButtonLabel: UILabel!
    @IBOutlet weak var secondaryPillModalButton: UIButton!
    @IBOutlet weak var secondaryPillTableView: UITableView!
    @IBOutlet weak var secondaryPillTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondaryPillFieldHeight: NSLayoutConstraint!

    //CalendarView
    @IBOutlet weak var calendarView: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setPillTableViews()

        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()

        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        secondaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)

        setCalendarView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()
    }

    @IBAction func selectTimeSegmentedControl(_ sender: Any) {
        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillListDataSource = primaryPillListMorning
        case 1:
            primaryPillListDataSource = primaryPillListLunch
        case 2:
            primaryPillListDataSource = primaryPillListDinner
        default:
            primaryPillListDataSource = []
        }
        reloadPrimaryPillTableView()
        primaryPillTableView.reloadData()
    }

    private func setStyle(){
        self.view.backgroundColor = UIColor.AColor.background
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }

    private func setPillTableViews() {
        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        secondaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        primaryPillTableView.delegate = self
        primaryPillTableView.dataSource = self
        secondaryPillTableView.delegate = self
        secondaryPillTableView.dataSource = self
    }

    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }

    private func setPrimaryPillViewStyle() {
        
        // Primary Pill 영역
        primaryPillField.layer.cornerRadius = 10
        primaryPillViewLinkLabel.font = UIFont.AFont.navigationButtonDescriptionLabel
        
        // 전체복용 버튼
        takingAllPrimaryPillsButton.tintColor = UIColor.AColor.white
        takingAllPrimaryPillsButton.backgroundColor = UIColor.AColor.accent
        takingAllPrimaryPillsButton.layer.cornerRadius = 10
        takingAllPrimaryPillsButton.setTitle("전체 복용", for: .normal)
        takingAllPrimaryPillsButton.titleLabel?.font = UIFont.AFont.buttonTitle
        
        
    }

    private func setSecondaryPillViewStyle() {
        
        // Secondary Pill 영역
        secondaryPillField.layer.cornerRadius = 10
        secondaryPillModalButtonLabel.font = UIFont.AFont.navigationButtonDescriptionLabel
    }

    private func reloadPrimaryPillTableView() {
        CoreDataManager.shared.sendPrimarypillToShowPrimaryPill()

        primaryPillList = CoreDataManager.shared.fetchShowPrimaryPill(selectedDate: date)
        primaryPillListMorning = CoreDataManager.shared.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListLunch = CoreDataManager.shared.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListDinner = CoreDataManager.shared.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillList)

        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            primaryPillListDataSource = primaryPillListMorning
        case 1:
            primaryPillListDataSource = primaryPillListLunch
        case 2:
            primaryPillListDataSource = primaryPillListDinner
        default:
            primaryPillListDataSource = []
        }

        resizingPrimaryPillTableViewHeight(dataCount: primaryPillListDataSource.count)
        primaryPillTableView.reloadData()
    }

    private func reloadSecondaryPillTableView() {
        secondaryPillList = CoreDataManager.shared.fetchShowSecondaryPill(selectedDate: date)
        resizingSecondaryPillTableViewHeight()
        secondaryPillTableView.reloadData()
    }

    private func resizingPrimaryPillTableViewHeight(dataCount count: Int) {
        primaryPillTableViewHeight.constant =
        count == 0 ? 40.0 :
        66.0 * CGFloat(count)
        primaryPillFieldHeight.constant = CGFloat(primaryPillTableViewHeight.constant) + 120
    }

    private func resizingSecondaryPillTableViewHeight() {
        secondaryPillTableViewHeight.constant =
        secondaryPillList.count == 0 ? 40.0 :
        66.0 * CGFloat(secondaryPillList.count)
        secondaryPillFieldHeight.constant = CGFloat(secondaryPillTableViewHeight.constant) + 60
    }

    // MARK: - IBActions
    
    @IBAction func tapAddConditionButton(_ sender: UIButton) {
        guard let checkConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckConditionViewController") as? CheckConditionViewController else { return }

        self.navigationController?.pushViewController(checkConditionViewController, animated: true)
    }

    @IBAction func tapTakingAllPrimaryPillsButton(_ sender: Any) {
        for pills in primaryPillListDataSource {
            pills.isTaking = true
            primaryPillTableView.reloadData()
        }
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController

        nextViewController.delegate = self

        self.present(nextViewController, animated: true)
    }

}

extension MedicationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == primaryPillTableView {
            return self.primaryPillListDataSource.count  == 0 ? 1 : self.primaryPillListDataSource.count
        } else {
            return self.secondaryPillList.count == 0 ? 1 : self.secondaryPillList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MedicationPillCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationPillCell else { return UITableViewCell() }

        cell.delegate = self

        if tableView == primaryPillTableView {

            if primaryPillListDataSource.count == 0 {

                guard let emptyCell: EmptyPrimaryPillCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPrimaryPillCell") as? EmptyPrimaryPillCell else { return UITableViewCell() }
                emptyCell.captionLabel.text = "먹어야할 약이 없어요"
                emptyCell.captionLabel.textColor = UIColor.AColor.gray
                emptyCell.captionLabel.font = UIFont.AFont.explainText

                return emptyCell

            } else {
                // Cell Data
                cell.pillImageView.image = UIImage(named: "primaryPill")
                cell.cellTitleLabel.text = primaryPillListDataSource[indexPath.row].name! + " " + primaryPillListDataSource[indexPath.row].dosage!
                // TODO: - 타임 스탬프
//                cell.pillTimeLabel.text = primaryPillListDataSource[indexPath.row].takeTime != nil ? dateFormatter.string(from:  primaryPillListDataSource[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
                cell.takingPillButton.isSelected = primaryPillListDataSource[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)

                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = true
            }
        } else {
            if secondaryPillList.count == 0 {

                guard let emptyCell: EmptySecondaryPillCell = tableView.dequeueReusableCell(withIdentifier: "EmptySecondaryPillCell") as? EmptySecondaryPillCell else { return UITableViewCell() }
                emptyCell.captionLabel.text = "추가로 복용한 약이 있다면 추가해주세요"
                emptyCell.captionLabel.textColor = UIColor.AColor.gray
                emptyCell.captionLabel.font = UIFont.AFont.explainText

                return emptyCell

            } else {
                // Image
                cell.pillImageView.image = UIImage(named: "secondaryPill")
                // Title
                cell.cellTitleLabel.text = secondaryPillList[indexPath.row].name! + " " + secondaryPillList[indexPath.row].dosage!
                // TODO: - TimeLog
//                cell.pillTimeLabel.text = secondaryPillList[indexPath.row].takeTime != nil ? dateFormatter.string(from: secondaryPillList[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
                // Taking Button
                cell.takingPillButton.isSelected = secondaryPillList[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)
                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = false

                // Style
                cell.takingPillButton.titleLabel?.font = UIFont.AFont.buttonText
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == primaryPillTableView || secondaryPillList.count == 0 {
            return false
        } else {
            return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == secondaryPillTableView {
            if editingStyle == .delete {
                CoreDataManager.shared.deleteShowSecondaryPill(pill: secondaryPillList[indexPath.row])
                secondaryPillList.remove(at: indexPath.row)
                if secondaryPillList.count != 0 {
                    secondaryPillTableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.reloadData()
                }
                resizingSecondaryPillTableViewHeight()
            }
        }
    }
}

extension MedicationViewController: AddSecondaryPillViewControllerDelegate {
    func didFinishModal() {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
        reloadSecondaryPillTableView()
    }
}

extension MedicationViewController: TakeMedicationDelegate {
    func setPillTake(rowNumber: Int, isPrimary: Bool) {
        if isPrimary {
            CoreDataManager.shared.recordHistoryAndChangeShowPrimaryIsTaking(showPrimaryPill: primaryPillListDataSource[rowNumber])
            primaryPillTableView.reloadData()
        } else {
            CoreDataManager.shared.recordHistoryAndChangeShowSecondaryIsTaking(showSecondaryPill: secondaryPillList[rowNumber])
            secondaryPillTableView.reloadData()
        }
    }
    func setPillNotTake(rowNumber: Int, isPrimary: Bool) {
        if isPrimary {
            CoreDataManager.shared.changePrimaryIsTakingAndCancelHistory(showPrimaryPill: primaryPillListDataSource[rowNumber])
            primaryPillTableView.reloadData()
        }
        else {
            CoreDataManager.shared.changeSecondaryIsTakingAndCancelHistory(showSecondaryPill: secondaryPillList[rowNumber])
            secondaryPillTableView.reloadData()
        }
    }
}

extension MedicationViewController: CalendarViewDelegate {
    func fetchDate(date: Date) {
        self.date = date
        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()
    }

    func setCalendarView() {
        calendarView.delegate = self
    }
}

// 비어있는 테이블에 대해서
class EmptyPrimaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}

class EmptySecondaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}
