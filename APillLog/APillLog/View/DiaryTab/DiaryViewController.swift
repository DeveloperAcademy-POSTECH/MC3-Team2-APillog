//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class DiaryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var mistakeTableView: UITableView!
    
    var coredataManager: CoreDataManager = CoreDataManager()
    let cellIdentifier = "NoteCell"
    var myCBT : [CBT] = [CBT()]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCBT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.mistakeTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
               cell.textLabel?.text = myCBT[indexPath.row].cbtContext ?? "text"
               return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mistakeTableView.delegate = self
        mistakeTableView.dataSource = self
        myCBT = coredataManager.fetchCBT()

        mistakeTableView.register(MyCustomHeader.self,
               forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myCBT = coredataManager.fetchCBT()
        mistakeTableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as! MyCustomHeader
       view.title.text = "실수노트"
         view.title.font = UIFont.AFont.tableViewTitle

       return view
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}

class customCell :UITableViewCell {
    
}
