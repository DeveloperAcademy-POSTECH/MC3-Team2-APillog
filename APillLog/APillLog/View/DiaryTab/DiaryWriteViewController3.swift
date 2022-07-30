//
//  DiaryWriteViewController3.swift
//  APillLog
//
//  Created by dohankim on 2022/07/30.
//

import UIKit
import WidgetKit

class DiaryWriteViewController3: UIViewController, UITextViewDelegate {

    var coredataManager: CoreDataManager = CoreDataManager()
    @IBOutlet weak var diaryWriteDatePicker3: UIDatePicker!
    @IBOutlet weak var diaryWriteTextView3: UITextView!
    
    var currentDate = Date()
    var mistakeString = ""
    var recognizeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diaryWriteDatePicker3.date = currentDate
        self.diaryWriteTextView3.becomeFirstResponder()
        // Do any additional setup after loading the view.
        self.diaryWriteTextView3.delegate = self
        diarySaveButton3.isEnabled = false
        diarySaveButton3.backgroundColor = UIColor.AColor.disable
        diaryWriteTextView3.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
    }
    @IBOutlet weak var diarySaveButton3: UIButton!
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            diarySaveButton3.isEnabled = false
            diarySaveButton3.backgroundColor = UIColor.AColor.disable
        }
        else{
            diarySaveButton3.isEnabled = true
            diarySaveButton3.backgroundColor = UIColor.AColor.accent
        }
        
       }
    @IBAction func didTapSaveButton3(_ sender: Any) {
        coredataManager.addCBT(selectDate: diaryWriteDatePicker3.date, mistakeContext: mistakeString, recognizeContext: recognizeString, actionContext: diaryWriteTextView3.text)
        self.navigationController?.popToRootViewController(animated: true)
        UserDefaults(suiteName:"group.com.varcode.APillLog.ApilogWidget")!.set(diaryWriteTextView3.text, forKey: "content")
                    WidgetCenter.shared.reloadAllTimelines()
        
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
