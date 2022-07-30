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
    @IBOutlet weak var versionTitle: UINavigationBar!
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
    
    let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.navigationItem.title = "버전정보"
        version.text = comparingVersion!
        version.font = UIFont.AFont.caption
        button.tintColor = UIColor.AColor.accent
        var check: Bool = needUpdate()
        if check == false {
            self.context.text =  "최신 버전을 사용하고 있어요"
        }
        else {
            self.context.text = "새로운 버전으로 업데이트 해주세요"
        }
        check.toggle()
        button.isHidden = check
    }
    
    func needUpdate() -> Bool {
        
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.varcode.APillLog"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
                
        else { return false }
        self.button.setTitle("버전" + appStoreVersion + " 업데이트", for: .normal)
        
        let nowVersionArr = version.split(separator: ".").map { $0 }
        let storeVersionArr = appStoreVersion.split(separator: ".").map { $0 }
        
        
        // 가장 앞자리가 다르면 -> 업데이트 필요
        if nowVersionArr[0] < storeVersionArr[0] {
            return true
        } else {
            if  nowVersionArr[1] < storeVersionArr[1] { // 두번째 자리가 달라도 업데이트 필요
                return true
            } else { return false } // 그 이외에는 업데이트 필요 없음
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
    
}
