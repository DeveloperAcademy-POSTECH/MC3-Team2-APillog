//
//  AddSecondaryPillViewController.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/18.
//

import UIKit

protocol AddSecondaryPillViewControllerDelegate {
    func didFinishModal()
}

class AddSecondaryPillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: @IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchKeyword: UILabel!
    @IBOutlet weak var addUnKnownPillStack: UIStackView!
    
    // MARK: Properties
    let cellIdentifier = "SecondaryPillTableViewCell"
    var delegate: AddSecondaryPillViewControllerDelegate! = nil
    
    
    var dummy: [String] = ["타이레놀정 500mg", "타이레놀정 160mg", "타이레놀정 80mg", "타이레놀현탁액 100ml", "부루펜시럽 80ml", "베아제정", "닥터베아제정", "훼스탈골드정", "훼스탈플러스정", "판콜에이내복액 30ml", "판피린티정", "제일쿨파스", "신신파스아렉스", "베아제정2", "닥터베아제정2", "훼스탈골드정2", "훼스탈플러스정2", "판콜에이내복액 30ml2", "판피린티정2", "제일쿨파스2", "신신파스아렉스2"]
    var filteredData: [String] = []
    
    
    // MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recentAddedPillNameList = fetchRecentAddedPillNameList()
        filteredData.append(contentsOf: recentAddedPillNameList)
        filteredData.append(contentsOf: dummy)
        
        addUnKnownPillStack.isHidden = true
    }
    
    
    // MARK: UITableViewDataSource
    // 화면 사이즈에 대응해 약 리스트를 보여주기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxCellNumber = Int((UIScreen.main.bounds.size.height - 80) / 80)
        
        return self.filteredData.count > maxCellNumber ? maxCellNumber : self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SecondaryPillTableViewCell = searchTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SecondaryPillTableViewCell else {
            return UITableViewCell()
        }
        cell.pillNameView.text = self.filteredData[indexPath.row]
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        CoreDataManager.shared.addShowSecondaryPill(name: filteredData[indexPath.row], dosage: "", selectDate: Date())
        CoreDataManager.shared.addRecentAddedSecondaryPill(name: filteredData[indexPath.row])
        self.delegate.didFinishModal()
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        addUnKnownPillStack.isHidden = false
        addUnKnownPillStack.isHidden = searchText.isEmpty ? true : false
        setSearchKeywordText(text: searchText)
        
        filteredData = []
        if searchText.isEmpty {
            filteredData = dummy
        } else {
            for data in dummy {
                if data.contains(searchText.lowercased()) {
                    filteredData.append(data)
                }
            }
        }
        
        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    // MARK: Function
    func setSearchKeywordText(text: String) {
        searchKeyword.text = text.isEmpty ? "없는 약 추가하기" : text
    }

    func fetchRecentAddedPillNameList() -> [String] {
        let recentAddedPillList = CoreDataManager.shared.fetchRecentAddedSecondaryPill()
        var recentAddedPillNameList: [String] = []
        
        for pill in recentAddedPillList {
            recentAddedPillNameList.insert(pill.name!, at: 0)
        }
        
        return recentAddedPillNameList
    }
    
    // MARK: @IBAction
    @IBAction func tapCancleButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tapAddPillButton() {
        CoreDataManager.shared.addShowSecondaryPill(name: self.searchBar.text!, dosage: "", selectDate: Date())
        CoreDataManager.shared.addRecentAddedSecondaryPill(name: self.searchBar.text!)
        delegate.didFinishModal()
        dismiss(animated: true)
    }
}

class SecondaryPillTableViewCell: UITableViewCell {
    @IBOutlet var pillNameView: UILabel!
}
