//
//  PreferencesViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/27.
//

import UIKit

class PreferencesViewController: UIViewController {
 
    @IBOutlet weak var featuresTable: UITableView!
    @IBOutlet weak var informationTable: UITableView!
    
    var information:[String] = ["라이센스","문의사항","버전정보","고마운 사람들"]
    var features:[String] = ["알림 설정"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        features = ["알림 설정"]
        information = ["라이센스","문의사항","버전정보","고마운 사람들"]
        
        let nibName = UINib(nibName: "PreferencesCell", bundle: nil)
        featuresTable.register(nibName, forCellReuseIdentifier:  "PreferencesCell")
        informationTable.register(nibName, forCellReuseIdentifier:  "PreferencesCell")
       
        informationTable.delegate = self
        informationTable.dataSource = self

        featuresTable.delegate = self
        featuresTable.delegate = self
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       

//        self.primaryPillTableView.addObserver(self, forKeyPath: "primaryPillTableViewContentSize", options: .new, context: nil)
    }
}
extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == featuresTable{
            print("count-----",features.count)
            return self.features.count
            
        }
        else{
           
            return self.information.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //   if tableView == informationTable{
        if tableView == featuresTable{
            let cell: PreferencesCell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! PreferencesCell
            
                cell.name.text = features[indexPath.row]
                cell.arrow.text = ">"
                return cell
        }
        else{
            let cell: PreferencesCell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! PreferencesCell
                cell.name.text = information[indexPath.row]
                cell.arrow.text = ">"
                return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
      
        let storyboard = UIStoryboard(name: "PreferencesView", bundle: nil)
        
        var vc: UIViewController
        
        switch indexPath.row {
        case 0:
            vc =  storyboard.instantiateViewController(withIdentifier: "LicenseView") as! LicenseViewController
        case 1:
            vc =  storyboard.instantiateViewController(withIdentifier: "QuestionsView") as! QuestionsViewController
        case 2:
            vc =  storyboard.instantiateViewController(withIdentifier: "VersionView") as! VersionViewController
        default:
            vc =  storyboard.instantiateViewController(withIdentifier: "ThanksToView") as! ThanksToViewController
            
            
        }
       
        navigationController?.pushViewController(vc, animated: true)
    }

}
