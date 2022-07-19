//
//  ManageDosingViewController.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/20.
//

import Foundation
import UIKit

class ManageDosingViewController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: Property
    
    
    // MARK: LifeCycle Function
    override func viewDidLoad() {
        
    }
}

extension ManageDosingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension ManageDosingViewController: UITableViewDelegate {
    
}

