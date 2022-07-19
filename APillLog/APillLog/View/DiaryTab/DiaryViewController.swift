//
//  DiaryViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class DiaryViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        // Do any additional setup after loading the view.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           hideKeyboard()
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func hideKeyboard() {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
