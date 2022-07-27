//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController
{
    
    let cellIdentifier = "medicationPillCell"
    
    var coreDataManager = CoreDataManager()
    
    var primaryPillList: [ShowPrimaryPill] = []
    var primaryPillListMorning: [ShowPrimaryPill] = []
    var primaryPillListLunch: [ShowPrimaryPill] = []
    var primaryPillListDinner: [ShowPrimaryPill] = []
    var primaryPillListDataSource: [ShowPrimaryPill] = []
    
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

//        self.primaryPillTableView.addObserver(self, forKeyPath: "primaryPillTableViewContentSize", options: .new, context: nil)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.primaryPillTableView.removeObserver(self, forKeyPath: "primaryPillTableViewContentSize")
//    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//            if keyPath == "primaryPillTableViewContentSize"
//            {
//                if object is UITableView
//                {
//                    if let newValue = change?[.newKey]{
//                        let newSize = newValue as! CGSize
//                        self.primaryPillTableViewHeight.constant = newSize.height
//                    }
//                }
//            }
//
//            if keyPath == "secondaryPillTableViewContentSize"
//            {
//                if object is UITableView
//                {
//                    if let newValue = change?[.newKey]{
//                        let newSize = newValue as! CGSize
//                        self.secondaryPillTableViewHeight.constant = newSize.height
//                    }
//                }
//            }
//        }

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
        // 특정 시간대 눌려있는 상태로 메인 약 추가 되었다가 돌아와서 다른 시간대 눌렀을 때 이전 시간대의 약 데이터가 남아있던 문제를 해결하기 위해 reloadPrimaryPillTableView 추가
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
        primaryPillField.layer.cornerRadius = 10
        primaryPillViewLinkLabel.font = UIFont.AFont.navigationButtonDescriptionLabel
        // Button Text가 너무 작아서 ButtonTitle이라는 새로운 값 추가
//        takingAllPrimaryPillsButton.titleLabel?.font = UIFont.AFont.buttonTitle
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillField.layer.cornerRadius = 10
        secondaryPillModalButtonLabel.font = UIFont.AFont.navigationButtonDescriptionLabel
    }
    
    private func reloadPrimaryPillTableView() {
        coreDataManager.sendPrimarypillToShowPrimaryPill()
            
        primaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: date)
        primaryPillListMorning = coreDataManager.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListLunch = coreDataManager.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListDinner = coreDataManager.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillList)

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

        primaryPillTableViewHeight.constant =
        primaryPillListDataSource.count == 0 ? 35.0 :
        65.0 * CGFloat(primaryPillListDataSource.count)
        primaryPillFieldHeight.constant = CGFloat(primaryPillTableViewHeight.constant) + 120

        primaryPillTableView.reloadData()
    }

    private func reloadSecondaryPillTableView() {
        secondaryPillList = coreDataManager.fetchShowSecondaryPill(selectedDate: date)

        secondaryPillTableViewHeight.constant =
        secondaryPillList.count == 0 ? 35.0 :
        65.0 * CGFloat(secondaryPillList.count)
        secondaryPillFieldHeight.constant = CGFloat(secondaryPillTableViewHeight.constant) + 60

        secondaryPillTableView.reloadData()
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    @IBAction func tapAddConditionButton(_ sender: UIButton) {
        guard let checkConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckConditionViewController") as? CheckConditionViewController else { return }
        
        self.navigationController?.pushViewController(checkConditionViewController, animated: true)
        
    }
}

extension MedicationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == primaryPillTableView {
            return self.primaryPillListDataSource.count == 0 ? 1 : self.primaryPillListDataSource.count
        } else {
            return self.secondaryPillList.count  == 0 ? 1 : self.secondaryPillList.count
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
                // Image
                cell.pillImageView.image = UIImage(named: "primaryPill")
                // Title
                cell.cellTitleLabel.text = primaryPillListDataSource[indexPath.row].name! + " " + primaryPillListDataSource[indexPath.row].dosage!
                // TODO: - 타임 스탬프
                // Time
//                cell.pillTimeLabel.text = primaryPillListDataSource[indexPath.row].takeTime != nil ? dateFormatter.string(from:  primaryPillListDataSource[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
                // Taking Button
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
                // Time
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView == secondaryPillTableView {
                // TODO: - SecondaryPill delete 함수
                coreDataManager.deleteShowSecondaryPill(pill: secondaryPillList[indexPath.row])
                
                secondaryPillList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else {
                return
            }
            return
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
            coreDataManager.recordHistoryAndChangeShowPrimaryIsTaking(showPrimaryPill: primaryPillListDataSource[rowNumber])
            primaryPillTableView.reloadData()
        } else {
            coreDataManager.recordHistoryAndChangeShowSecondaryIsTaking(showSecondaryPill: secondaryPillList[rowNumber])
            secondaryPillTableView.reloadData()
        }
    }
    func setPillNotTake(rowNumber: Int, isPrimary: Bool) {
        if isPrimary {
            coreDataManager.changePrimaryIsTakingAndCancelHistory(showPrimaryPill: primaryPillListDataSource[rowNumber])
            primaryPillTableView.reloadData()
        }
        else {
            coreDataManager.changeSecondaryIsTakingAndCancelHistory(showSecondaryPill: secondaryPillList[rowNumber])
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
