//
//  QuestionsController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/28.
//

import Foundation
import UIKit
import MessageUI

class QuestionsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var questiontitle: UINavigationBar!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var requestText: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UINavigationItem!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        self.view.backgroundColor = UIColor.AColor.background
        self.navigationController?.navigationBar.tintColor = .green
        self.navigationItem.hidesBackButton = true
        }
        
        func showSendMailErrorAlert() {
            let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) {
                (action) in
                print("확인")
            }
            sendMailErrorAlert.addAction(confirmAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        @IBAction func backToPreferences(){
        
        }
        @IBAction func sendEmailTapped(_ sender: UIButton) {
            
            if MFMailComposeViewController.canSendMail() {
                
                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = self
                
                compseVC.setToRecipients(["youbellgun@naver.com"])
                compseVC.setSubject("Message Subject")
                compseVC.setMessageBody("Message Content", isHTML: false)
                
                self.present(compseVC, animated: true, completion: nil)
                
            }
            else {
                self.showSendMailErrorAlert()
            }
            
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }

    
}
