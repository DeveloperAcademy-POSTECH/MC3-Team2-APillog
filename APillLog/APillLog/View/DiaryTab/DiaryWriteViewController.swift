//
//  DiaryWriteViewController.swift
//  APillLog
//
//  Created by dohankim on 2022/07/20.
//

import UIKit
import CoreData
import WidgetKit

class DiaryWriteViewController: UIViewController, UITextViewDelegate {
    var coredataManager: CoreDataManager = CoreDataManager()
    @IBOutlet weak var mistakeTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var diaryWriteDatePicker1 : UIDatePicker!
    
    
    @IBOutlet weak var diaryWriteSaveButton1: UIButton!
    
    
    var mistakeString = ""
    var currentDate = Date()
    @IBAction func didTapSaveButton1(_ sender: Any) {
        currentDate = diaryWriteDatePicker1.date
//        self.performSegue(withIdentifier: "DiaryWriteView2", sender: self)
//        diaryWriteDatePicker2.date = currentDate
    }
    
    
//    @IBAction func didTapSaveButton(_ sender: Any) {
//
//        if  !actionTextView.text.trimmingCharacters(in: .whitespaces).isEmpty && !mistakeTextView.text.trimmingCharacters(in: .whitespaces).isEmpty{
//            coredataManager.addCBT(selectDate: diaryWriteDatePicker1.date,mistakeContext: mistakeTextView.text,recognizeContext: recognizeTextView.text,actionContext: actionTextView.text)
//            _ = navigationController?.popViewController(animated: true)
//
//            UserDefaults(suiteName:
//                            "group.com.varcode.APillLog.ApilogWidget")!.set(actionTextView.text, forKey: "content")
//            WidgetCenter.shared.reloadAllTimelines()
//        }
//        else{
//            _ = navigationController?.popViewController(animated: true)
//        }
        

//        coredataManager.addCBT(selectDate: diaryWriteDatePicker.date, mistakeContext: mistakeTextView.text, recognizeContext: recognizeTextView.text!, actionContext: actionTextView.text!)
//        _ = navigationController?.popViewController(animated: true)

//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var borderColor : UIColor = UIColor.AColor.accent
        mistakeTextView.delegate = self
        mistakeTextView.layer.borderWidth = 1
        mistakeTextView.layer.borderColor = borderColor.cgColor
        diaryWriteSaveButton1.isEnabled = false
        diaryWriteSaveButton1.backgroundColor = UIColor.AColor.disable
        mistakeTextView.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            diaryWriteSaveButton1.isEnabled = false
            diaryWriteSaveButton1.backgroundColor = UIColor.AColor.disable
        }
        else{
            diaryWriteSaveButton1.isEnabled = true
            diaryWriteSaveButton1.backgroundColor = UIColor.AColor.accent
        }
        
       }
    override func viewDidAppear(_ animated: Bool) {
        
            self.mistakeTextView.becomeFirstResponder()
        
        
        
        
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
             if (segue.identifier == "DiaryWriteView2"){
                 let displayVC = segue.destination as! DiaryWriteViewController2
              
               //Assigns the name entered in the AViewController to display it in BViewController
               
                 displayVC.currentDate = diaryWriteDatePicker1.date
                 displayVC.mistakeString = mistakeTextView.text
                 
             }
         }
}


