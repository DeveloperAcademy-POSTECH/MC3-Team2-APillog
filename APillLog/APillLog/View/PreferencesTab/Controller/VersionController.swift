//
//  VersionController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/28.
//

import Foundation
import UIKit
enum AppstoreOpenError: Error {
    case invalidAppStoreURL
    case cantOpenAppStoreURL
}
class VersionViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var button: UIButton!
     let appStoreOpenUrlString = "https://apps.apple.com/kr/app/apillog/id1636467512"
    var comparingVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String else {return nil}

        let versionAndBuild: String = "vserion: \(version), build: \(build)"
        return versionAndBuild
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           // 앱 버전 체크 실행
        
        version.text = comparingVersion! + "최신: "
        //+ latestVersion()!
        
          
       }
    static func latestVersion() -> String? {
        let appleID = "youbellgun@naver.com"
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
       
    struct System {
        static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        static func latestVersion() -> String? {
            let appleID = "youbellgun@naver.com"
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
                  let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            return appStoreVersion
        }
    }
    @IBAction func goAppSore(){
        openAppStore(urlStr: appStoreOpenUrlString)
    }
    func openAppStore(urlStr: String) -> Result<Void, AppstoreOpenError> {

          guard let url = URL(string: urlStr) else {
              print("invalid app store url")
              return .failure(.invalidAppStoreURL)
          }

          if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
              return .success(())
          } else {
              print("can't open app store url")
              return .failure(.cantOpenAppStoreURL)
          }
      }
    
    func latestVersion() -> String? {
            let appleID = "이곳에 Apple ID"
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
                  let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            return appStoreVersion
        }

//       func checkVersionTask() {
//           _ = try? AppVersionCheck.isUpdateAvailable { (update, error) in
//               if let error = error {
//                   print(error)
//               } else if let update = update {
//                   if update {
//                       print("This App is old version")
//                       self.appUpdate()
//                       return
//                   } else {
//                       print("This App is latest version")
//                       return
//                   }
//               }
//           }
//       }
//
//       // AppStore 이동
//       func appUpdate() {
//           let appleId = "Apple ID"        // 앱 스토어에 일반 정보의 Apple ID 입력
//           // UIApplication 은 Main Thread 에서 처리
//           DispatchQueue.main.async {
//               if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleId)"), UIApplication.shared.canOpenURL(url) {
//                   if #available(iOS 10.0, *) {
//                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                   } else {
//                       UIApplication.shared.openURL(url)
//                   }
//               }
//           }
//       }
}
