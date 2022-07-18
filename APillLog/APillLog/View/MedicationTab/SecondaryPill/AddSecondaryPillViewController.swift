//
//  AddSecondaryPillViewController.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/18.
//

import UIKit

protocol AddSecondaryPillViewControllerDelegate {
    func modalDidFinished(selectedPill: String)
}

class AddSecondaryPillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: @IBOutlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchKeyword: UILabel!
    
    // MARK: Properties
    let cellIdentifier = "SecondaryPillTableViewCell"
    
    var dummy: [String] = ["타이레놀정 500mg", "타이레놀정 160mg", "타이레놀정 80mg", "타이레놀현탁액 100ml", "부루펜시럽 80ml", "베아제정", "닥터베아제정", "훼스탈골드정", "훼스탈플러스정", "판콜에이내복액 30ml", "판피린티정", "제일쿨파스", "신신파스아렉스", "베아제정2", "닥터베아제정2", "훼스탈골드정2", "훼스탈플러스정2", "판콜에이내복액 30ml2", "판피린티정2", "제일쿨파스2", "신신파스아렉스2"]
    var filteredData: [String]!
    
    
    // MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredData = dummy
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
        return 55
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    
    // MARK: Function
    func setSearchKeywordText(text: String) {
        
        if text.isEmpty {
            searchKeyword.text = "없는 약 추가하기"
        } else {
            searchKeyword.text = "'\(text)'"
        }
    }
    
    // MARK: @IBAction
    @IBAction func tapCancleButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tapAddPillButton() {
        dismiss(animated: true)
    }
}

class SecondaryPillTableViewCell: UITableViewCell {
    @IBOutlet var pillNameView: UILabel!
}
