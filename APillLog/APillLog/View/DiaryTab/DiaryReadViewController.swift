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
    var recognizeString = ""
    var actionString = ""
    var id  = UUID()
    var receivedCBT : CBT = CBT()
    var coredataManager: CoreDataManager = CoreDataManager()
    @IBOutlet weak var DiaryReadViewDate: UILabel!
    @IBOutlet weak var DiaryReadViewBody: UITextView!
    @IBOutlet weak var DiaryReadRecognizeString: UITextView!
    @IBOutlet weak var DiaryReadActionString: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var borderColor : UIColor = UIColor.AColor.accent
        DiaryReadViewBody.text = body
        DiaryReadViewDate.text = date
        DiaryReadActionString.text = actionString
        DiaryReadRecognizeString.text = recognizeString
        self.navigationController?.title = "에필로그"
        DiaryReadViewBody.layer.borderWidth = 2
        DiaryReadViewBody.layer.borderColor = borderColor.cgColor
        DiaryReadViewBody.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        DiaryReadRecognizeString.layer.borderWidth = 2
        DiaryReadRecognizeString.layer.borderColor = borderColor.cgColor
        DiaryReadRecognizeString.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        DiaryReadActionString.layer.borderWidth = 2
        DiaryReadActionString.layer.borderColor = borderColor.cgColor
        DiaryReadActionString.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        receivedCBT.mistakeContext = DiaryReadViewBody.text
        receivedCBT.selectDate = DiaryReadViewDate.text
        coredataManager.updateOneCBT(receivedCBT: receivedCBT)
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
