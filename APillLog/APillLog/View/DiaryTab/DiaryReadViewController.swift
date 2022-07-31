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
        DiaryReadViewBody.layer.borderWidth = 1
        DiaryReadViewBody.layer.borderColor = borderColor.cgColor
        DiaryReadViewBody.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        DiaryReadRecognizeString.layer.borderWidth = 1
        DiaryReadRecognizeString.layer.borderColor = borderColor.cgColor
        DiaryReadRecognizeString.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        DiaryReadActionString.layer.borderWidth = 1
        DiaryReadActionString.layer.borderColor = borderColor.cgColor
        DiaryReadActionString.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
//        receivedCBT.mistakeContext = DiaryReadViewBody.text
//        receivedCBT.selectDate = DiaryReadViewDate.text
//        coredataManager.updateOneCBT(receivedCBT: receivedCBT)
    }
    
    @IBAction func editMistake(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "DiaryEditView") as! DiaryEditViewController
        vc.receivedCBT = receivedCBT
        vc.type = 1
        vc.date = date
        vc.questionString = "오늘 하루 후회되는 일이 있나요?"
        vc.textViewContent = body
        vc.mistakeString = body
        vc.recognizeString = recognizeString
        vc.actionString = actionString
        vc.completioHandler = {
                    msg in
                    print("messgae : \(msg)")
            self.DiaryReadViewBody.text = msg
                }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editRecognize(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "DiaryEditView") as! DiaryEditViewController
        vc.type = 2
        vc.receivedCBT = receivedCBT
        vc.date = date
        vc.questionString = "왜 후회하나요?"
        vc.textViewContent = recognizeString
        vc.mistakeString = body
        vc.recognizeString = recognizeString
        vc.actionString = actionString
        vc.completioHandler = {
                    msg in
            self.DiaryReadRecognizeString.text = msg
                }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "DiaryEditView") as! DiaryEditViewController
        vc.type = 3
        vc.receivedCBT = receivedCBT
        vc.date = date
        vc.questionString = "내일의 나는 어떻게 행동하면 좋을까요?"
        vc.textViewContent = actionString
        vc.mistakeString = body
        vc.recognizeString = recognizeString
        vc.actionString = actionString
        vc.completioHandler = {
                    msg in
            self.DiaryReadActionString.text = msg
                }
        navigationController?.pushViewController(vc, animated: true)
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
