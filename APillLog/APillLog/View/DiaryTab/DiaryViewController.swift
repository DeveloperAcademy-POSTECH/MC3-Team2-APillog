//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class DiaryViewController: UIViewController {


    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
               NotificationCenter.default.addObserver(self, selector: #selector(DiaryViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

               // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
               NotificationCenter.default.addObserver(self, selector: #selector(DiaryViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(notification: NSNotification) {
                
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }
          
          // move the root view up by the distance of keyboard height
          self.view.frame.origin.y = 0 - keyboardSize.height
        }

        @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
          self.view.frame.origin.y = 0
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
