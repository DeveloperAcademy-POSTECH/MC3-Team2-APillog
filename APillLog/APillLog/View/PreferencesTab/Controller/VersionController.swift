//
//  VersionController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/28.
//

import Foundation
import UIKit

class VersionViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           // 앱 버전 체크 실행
           checkVersionTask()
       }
       

       func checkVersionTask() {
           _ = try? AppVersionCheck.isUpdateAvailable { (update, error) in
               if let error = error {
                   print(error)
               } else if let update = update {
                   if update {
                       print("This App is old version")
                       self.appUpdate()
                       return
                   } else {
                       print("This App is latest version")
                       return
                   }
               }
           }
       }
       
       // AppStore 이동
       func appUpdate() {
           let appleId = "Apple ID"        // 앱 스토어에 일반 정보의 Apple ID 입력
           // UIApplication 은 Main Thread 에서 처리
           DispatchQueue.main.async {
               if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleId)"), UIApplication.shared.canOpenURL(url) {
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
               }
           }
       }
}
