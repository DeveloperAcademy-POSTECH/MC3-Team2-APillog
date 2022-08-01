//
//  DiaryEditViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/07/31.
//

import UIKit
import WidgetKit

class DiaryEditViewController: UIViewController, UITextViewDelegate {

    var date = ""
    var textViewContent = ""
    var questionString = ""
    var mistakeString = ""
    var recognizeString = ""
    var actionString = ""
    var receivedCBT : CBT = CBT()
    var coredataManager: CoreDataManager = CoreDataManager()
    var completioHandler : ((String) -> (Void))?
    var type = 0
    @IBOutlet weak var DiaryEditSaveButton: UIButton!
    @IBOutlet weak var DiaryEditTextView: UITextView!
    @IBOutlet weak var DiaryEditString: UILabel!
    @IBOutlet weak var DiaryEditDateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = UIColor.AColor.accent
        DiaryEditDateLabel.text = date
        DiaryEditString.text = questionString
        DiaryEditTextView.text = textViewContent
        DiaryEditTextView.becomeFirstResponder()
        DiaryEditTextView.delegate = self
        DiaryEditTextView.layer.borderWidth = 1
        DiaryEditTextView.layer.borderColor = borderColor.cgColor
        // Do any additional setup after loading the view.
        DiaryEditSaveButton.isEnabled = false
        DiaryEditSaveButton.backgroundColor = UIColor.AColor.disable
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "뒤로"
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            DiaryEditSaveButton.isEnabled = false
            DiaryEditSaveButton.backgroundColor = UIColor.AColor.disable
        }
        else{
            DiaryEditSaveButton.isEnabled = true
            DiaryEditSaveButton.backgroundColor = UIColor.AColor.accent
        }
        
       }
    @IBAction func didFinishEdit(_ sender: Any) {
        if type == 1 {
            completioHandler?(DiaryEditTextView.text)
            receivedCBT.mistakeContext = DiaryEditTextView.text
            coredataManager.updateOneCBT(receivedCBT: receivedCBT)
        }
        else if type == 2 {
            completioHandler?(DiaryEditTextView.text)
            receivedCBT.recognizeContext = DiaryEditTextView.text
            coredataManager.updateOneCBT(receivedCBT: receivedCBT)

        }
        else{
            completioHandler?(DiaryEditTextView.text)
            receivedCBT.actionContext = DiaryEditTextView.text
            coredataManager.updateOneCBT(receivedCBT: receivedCBT)
        }
        
        
        
        navigationController?.popViewController(animated: true)
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
