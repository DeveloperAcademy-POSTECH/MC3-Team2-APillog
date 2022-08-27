//
//  DiaryWriteViewController2.swift
//  APillLog
//
//  Created by dohankim on 2022/07/30.
//

import UIKit

class DiaryWriteViewController2: UIViewController, UITextViewDelegate {
    var currentDate = Date()
    var mistakeString = ""
    @IBOutlet weak var diaryWriteDatePicker2: UIDatePicker!
    @IBOutlet weak var diaryWriteTextView2: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = UIColor.AColor.accent
        self.diaryWriteDatePicker2.date = currentDate
        self.diaryWriteTextView2.becomeFirstResponder()
        diaryWriteTextView2.delegate = self
        diaryWriteTextView2.layer.borderWidth = 1
        diaryWriteTextView2.layer.borderColor = borderColor.cgColor
        diarySaveButton2.isEnabled = false
        diarySaveButton2.backgroundColor = UIColor.AColor.disable
        diaryWriteTextView2.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "뒤로"
    }
    @IBOutlet weak var diarySaveButton2: UIButton!
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            diarySaveButton2.isEnabled = false
            diarySaveButton2.backgroundColor = UIColor.AColor.disable
        }
        else{
            diarySaveButton2.isEnabled = true
            diarySaveButton2.backgroundColor = UIColor.AColor.accent
        }
        
    }
    @IBAction func didTabDiarySave(_ sender: Any) {
        currentDate = diaryWriteDatePicker2.date
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DiaryWriteView3"){
            let displayVC = segue.destination as! DiaryWriteViewController3
            
            //Assigns the name entered in the AViewController to display it in BViewController
            
            displayVC.currentDate = diaryWriteDatePicker2.date
            displayVC.mistakeString = mistakeString
            displayVC.recognizeString = diaryWriteTextView2.text
            
        }
    }
}
