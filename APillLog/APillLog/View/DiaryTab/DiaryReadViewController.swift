//
//  DiaryReadViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/07/21.
//

import UIKit
import CoreData

class DiaryReadViewController: UIViewController {

    var date = ""
    var body = ""
    var id  = UUID()
    var coredataManager: CoreDataManager = CoreDataManager()
    @IBOutlet weak var DiaryReadViewDate: UILabel!
    @IBOutlet weak var DiaryReadViewBody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DiaryReadViewBody.text = body
        DiaryReadViewDate.text = date
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        coredataManager.updateOneCBT(cbtUUID: id, cbtUpdateContext: DiaryReadViewBody.text)
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
