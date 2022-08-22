//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit
import Charts

protocol MedicationViewToEditTimeViewDelegate {
    func configure(pill: ShowPrimaryPill)
}

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
    var historyData = [History]()
    var medicationViewToEditTimeDelegate: MedicationViewToEditTimeViewDelegate?
    private var nowDosingTime: Int16 = 1

    var takingTime: Date = Date()
    var isToday: Bool = true
    var selectedTime: Date = Date()
    
    let dateFormatterForCompare: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    // MARK: - IBOutlets
    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    @IBOutlet weak var symptomButtonStack: UIStackView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillViewTitle: UILabel!
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var primaryPillViewLinkLabel: UILabel!
    @IBOutlet weak var primaryPillViewLinkImage: UIImageView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var primaryPillFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var takingAllPrimaryPillsButton: UIButton!
    
    // Secondary Pill
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButtonLabel: UILabel!
    @IBOutlet weak var secondaryPillModalButtonImage: UIImageView!
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
        
        ConnectionModelPhone.shared.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyData = CoreDataManager.shared.fetchHistory(selectedDate: date)
        ConnectionModelPhone.shared.sendShowPrimaryPillToWatch()
    }

    @IBAction func selectTimeSegmentedControl(_ sender: Any) {
        switch(timeSegmentedControl.selectedSegmentIndex) {
        case 0:
            nowDosingTime = 1
            primaryPillListDataSource = primaryPillListMorning
        case 1:
            primaryPillListDataSource = primaryPillListLunch
            nowDosingTime = 2
        case 2:
            primaryPillListDataSource = primaryPillListDinner
            nowDosingTime = 4
        default:
            primaryPillListDataSource = []
        }
        setTakingAllPrimaryPillButtonColor()
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
        symptomButtonBackgroundView.layer.shadowOpacity = 0.2
        symptomButtonBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        symptomButtonBackgroundView.layer.shadowRadius = 1
    }
    
    private func setPrimaryPillViewStyle() {
        
        // 버튼 UI
        primaryPillViewLinkImage.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(font: NSUIFont.AFont.navigationButtonDescriptionLabel))
        
        // Primary Pill 영역
        primaryPillField.layer.cornerRadius = 10
        primaryPillViewLinkLabel.font = UIFont.AFont.navigationButtonDescriptionLabel
        
        // 전체복용 버튼
        takingAllPrimaryPillsButton.tintColor = UIColor.AColor.white
        takingAllPrimaryPillsButton.layer.cornerRadius = 10
        takingAllPrimaryPillsButton.setTitle("전체 복용", for: .normal)
        takingAllPrimaryPillsButton.titleLabel?.font = UIFont.AFont.buttonTitle
        takingAllPrimaryPillsButton.backgroundColor = UIColor.AColor.disable
        setTakingAllPrimaryPillButtonColor()
    }

    func setTakingAllPrimaryPillButtonColor() {
        var takingPillCount = 0
        for pill in primaryPillListDataSource {
            if pill.isTaking {
                takingPillCount += 1
            }
        }
        if takingPillCount == primaryPillListDataSource.count {
            takingAllPrimaryPillsButton.backgroundColor = UIColor.AColor.disable
        } else {
            takingAllPrimaryPillsButton.backgroundColor = UIColor.AColor.accent
        }
    }

    private func setSecondaryPillViewStyle() {
        // 버튼 UI
        secondaryPillModalButtonImage.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: NSUIFont.AFont.navigationButtonDescriptionLabel))

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

    private func checkIsToday(selectedDate: Date) {
        self.isToday = (dateFormatterForCompare.string(from: selectedDate) == dateFormatterForCompare.string(from: Date()))
        self.selectedTime = selectedDate
    }

    private func setPrimaryTableViewTitleText() {
        if isToday {
            primaryPillViewTitle.text = "오늘 복용할 약이에요"
        } else {
            primaryPillViewTitle.text = "이전에 복용했던 약이예요"
        }
    }

    private func setAddPillButtonsActivation() {
        if isToday {
            // primary
            primaryPillViewLinkButton.isHidden = false
            primaryPillViewLinkLabel.isHidden = false
            primaryPillViewLinkImage.isHidden = false
            primaryPillViewLinkLabel.textColor = .AColor.black
            primaryPillViewLinkImage.tintColor = .AColor.black

            // secondary
            secondaryPillModalButton.isHidden = false
            secondaryPillModalButtonLabel.isHidden = false
            secondaryPillModalButtonImage.isHidden = false
        } else {
            // primary
            primaryPillViewLinkButton.isHidden = true
            primaryPillViewLinkLabel.isHidden = true
            primaryPillViewLinkImage.isHidden = true
            
            // secondary
            secondaryPillModalButton.isHidden = true
            secondaryPillModalButtonLabel.isHidden = true
            secondaryPillModalButtonImage.isHidden = true
        }
    }

    private func setSymptomButtonAvailable() {
        if isToday {
            symptomButtonStack.isHidden = false
        } else {
            symptomButtonStack.isHidden = true
        }
    }

    // MARK: - IBActions
    @IBAction func tapAddConditionButton(_ sender: UIButton) {
        guard let checkConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckConditionViewController") as? CheckConditionViewController else { return }

        self.navigationController?.pushViewController(checkConditionViewController, animated: true)
    }

    @IBAction func tapTakingAllPrimaryPillsButton(_ sender: Any) {
        CoreDataManager.shared.recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date(), dosingCycle: Int16(nowDosingTime), takingTime: changeDateFormat(date: takingTime))

        setTakingAllPrimaryPillButtonColor()
        reloadPrimaryPillTableView()
        primaryPillTableView.reloadData()
        
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        nextViewController.delegate = self
        nextViewController.selectedTime = self.selectedTime
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
        cell.editTimeDelegate = self

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
                // Time Log
                cell.timeLogLabel.text = primaryPillListDataSource[indexPath.row].takeTime == nil ? "아직 복용 전이에요" : dateFormatter.string(from: primaryPillListDataSource[indexPath.row].takeTime!) + "에 복용했어요"

                cell.takingPillButton.isSelected = primaryPillListDataSource[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)
                
                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = true
                
                // Style
                cell.timeLogLabel.font = UIFont.AFont.explainText
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
                // Time Log
                cell.timeLogLabel.text = secondaryPillList[indexPath.row].takeTime == nil ? "아직 복용 전이에요" : dateFormatter.string(from: secondaryPillList[indexPath.row].takeTime!) + "에 복용했어요"

                // Taking Button
                cell.takingPillButton.isSelected = secondaryPillList[indexPath.row].isTaking
                cell.changeTakingPillButtonState(cell.takingPillButton)
                // Data for delegate
                cell.rowNumber = indexPath.row
                cell.isPrimary = false
                
                // Style
                cell.timeLogLabel.font = UIFont.AFont.explainText
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
                reloadSecondaryPillTableView()
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
            CoreDataManager.shared.recordHistoryAndChangeShowPrimaryIsTaking(showPrimaryPill: primaryPillListDataSource[rowNumber], takingTime: changeDateFormat(date: takingTime))
            primaryPillTableView.reloadData()
            ConnectionModelPhone.shared.sendShowPrimaryPillToWatch()
        } else {
            CoreDataManager.shared.recordHistoryAndChangeShowSecondaryIsTaking(showSecondaryPill: secondaryPillList[rowNumber], takingTime: changeDateFormat(date: takingTime))
            secondaryPillTableView.reloadData()
        }
    }

    func setPillNotTake(rowNumber: Int, isPrimary: Bool) {
        // 복용된 상태에서 alert가 떠있을 때 v가 안보이는 경우를 해결하기 위해 추가
        if isPrimary{
            self.primaryPillTableView.reloadData()
        } else {
            self.secondaryPillTableView.reloadData()
        }

        let alert = UIAlertController(title: "복용 기록을 삭제하시겠어요?", message: "복용 전 상태로 돌아가며, 복용 시각 데이터는 사라집니다.", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            if isPrimary{
                self.primaryPillTableView.reloadData()
            } else {
                self.secondaryPillTableView.reloadData()
            }
            self.setTakingAllPrimaryPillButtonColor()
        })

        let delete = UIAlertAction(title: "기록 삭제", style: .destructive, handler: { action in
            if isPrimary {
                CoreDataManager.shared.changePrimaryIsTakingAndCancelHistory(showPrimaryPill: self.primaryPillListDataSource[rowNumber])
                self.primaryPillTableView.reloadData()
            } else {
                CoreDataManager.shared.changeSecondaryIsTakingAndCancelHistory(showSecondaryPill: self.secondaryPillList[rowNumber])
                self.secondaryPillTableView.reloadData()
            }
            self.setTakingAllPrimaryPillButtonColor()
        })

        alert.addAction(cancel)
        alert.addAction(delete)

        present(alert, animated: true, completion: nil)
    }
}

extension MedicationViewController: EditTimeDelegate {
    func editTakingPillTime(rowNumber: Int, isPrimary: Bool) {

        let storyboard = UIStoryboard(name: "EditTimeModalView", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EditTimeModalViewController") as? EditTimeModalViewController else {
            return
        }

        viewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet

        if isPrimary && primaryPillListDataSource[rowNumber].isTaking {
            viewController.configure(pill: primaryPillListDataSource[rowNumber])
        }
        else if !isPrimary && secondaryPillList[rowNumber].isTaking {
            viewController.configure(pill: secondaryPillList[rowNumber])
        }
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}

extension MedicationViewController: EditTimeViewToMedicationViewDelegate {
    func didTimeChanged(isPrimary: Bool) {
        if isPrimary {
            primaryPillTableView.reloadData()

            ConnectionModelPhone.shared.sendShowPrimaryPillToWatch()
        }
        else {
            secondaryPillTableView.reloadData()
        }
    }
}

// Watch
extension MedicationViewController: ConnectionModelPhoneDelegate {
    func reloadTableView() {
        reloadPrimaryPillTableView()
    }
}

extension MedicationViewController: CalendarViewDelegate {
    func fetchDate(date: Date) {
        self.date = date

        checkIsToday(selectedDate: date)

        reloadPrimaryPillTableView()
        reloadSecondaryPillTableView()

        setPrimaryTableViewTitleText()
        setAddPillButtonsActivation()
        setSymptomButtonAvailable()

        takingTime = date
    }
    
    func setCalendarView() {
        calendarView.delegate = self
    }

    func changeDateFormat(date: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        let calendarSelectedDate: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let currentTime: String = dateFormatter.string(from: Date())
        let takingTime = calendarSelectedDate + " " + currentTime
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: takingTime) ?? Date()
    }

}
// 비어있는 테이블에 대해서
class EmptyPrimaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}

class EmptySecondaryPillCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
}
