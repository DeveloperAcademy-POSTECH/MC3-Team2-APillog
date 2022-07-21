//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController, AddSecondaryPillViewControllerDelegate {
    
    let cellIdentifier = "medicationPillCell"
    var coreDataManager = CoreDataManager()
    var primaryPillList: [ShowPrimaryPill] = []
    
    var primaryPillListMorning: [ShowPrimaryPill] = []
    var primaryPillListLunch: [ShowPrimaryPill] = []
    var primaryPillListDinner: [ShowPrimaryPill] = []
    
    var primaryPillListDataSource: [ShowPrimaryPill] = []
    
    // MARK: - IBOutlets
    
    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    @IBOutlet weak var primaryPillTableView: UITableView!
    
    // Secondary Pill
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!
    @IBOutlet weak var secondaryPillTableView: UITableView!
    
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        
        primaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: Date())
        primaryPillListMorning = coreDataManager.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListLunch = coreDataManager.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListDinner = coreDataManager.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillList)
        
        primaryPillListDataSource = primaryPillListMorning
        
        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coreDataManager.sendPrimarypillToShowPrimaryPill()
        primaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: Date())
        print(primaryPillList.count)
        primaryPillTableView.reloadData()
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
        primaryPillTableView.reloadData()
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
    
    
    @IBAction func tapAddConditionButton(_ sender: UIButton) {
        guard let checkConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckConditionViewController") as? CheckConditionViewController else { return }
        
        self.navigationController?.pushViewController(checkConditionViewController, animated: true)
        
    }
}

extension MedicationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == primaryPillTableView {
            print(self.primaryPillListDataSource.count)
            return self.primaryPillListDataSource.count
        } else {
            return 0
        }
        
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            return dateFormatter
        }()
        
        guard let cell: MedicationPillCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationPillCell else { return UITableViewCell() }
        
        if tableView == primaryPillTableView {
            // Image
            cell.pillImageView.image = UIImage(named: "primaryPill")
            // Title
            cell.cellTitleLabel.text = primaryPillListDataSource[indexPath.row].name! + " " + primaryPillListDataSource[indexPath.row].dosage!
            
            // Time
            cell.pillTimeLabel.text = primaryPillListDataSource[indexPath.row].takeTime != nil ? dateFormatter.string(from:  primaryPillListDataSource[indexPath.row].takeTime!) + "에 먹었어요" : "아직 복약 전이예요"
            
            // Style
            cell.cellTitleLabel.font = UIFont.AFont.chipText
            cell.pillTimeLabel.font = UIFont.AFont.caption
        } else {
            // Image
            cell.pillImageView.image = UIImage(named: "secondaryPill")
            // Title
            cell.cellTitleLabel.text = "test"
            // Time
            cell.pillTimeLabel.text = "test"
            // Style
            cell.cellTitleLabel.font = UIFont.AFont.chipText
            cell.pillTimeLabel.font = UIFont.AFont.caption
        }
        
        return cell
    }
    
    
}
