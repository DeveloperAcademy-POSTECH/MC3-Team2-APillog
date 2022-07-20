//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class DiaryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var mistakeTableView: UITableView!
    
    let cellIdentifier = "NoteCell"
    var myData = ["사과","당근","카카오","샐러드"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.mistakeTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
               cell.textLabel?.text = myData[indexPath.row]
               return cell
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        mistakeTableView.delegate = self
        mistakeTableView.dataSource = self
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
