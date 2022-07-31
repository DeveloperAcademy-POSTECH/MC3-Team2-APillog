//
//  PreferencesViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/27.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    // MARK: View LifeCycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.view.backgroundColor = UIColor.AColor.background
        self.settingCellStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
    }
   
    // MARK: @IBOutlet
    @IBOutlet weak var settingNotificationView: UIView!
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var thanksToView: UIView!
    @IBOutlet weak var questionsView: UIView!
    
    // MARK: Style Function
    func settingCellStyle() {
        self.settingNotificationView.layer.cornerRadius = 14
        self.licenseView.layer.cornerRadius = 14
        self.questionsView.layer.cornerRadius = 14
        self.versionView.layer.cornerRadius = 14
        self.thanksToView.layer.cornerRadius = 14
    }
    
    // MARK: @IBAction
    @IBAction func tapSettingNotificationButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PushNotificationView", bundle: nil)

        let vc =  storyboard.instantiateViewController(withIdentifier: "PushNotificationView") as! PushNotificationController

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapLicenseButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LicenseView", bundle: nil)
                    
        let vc = storyboard.instantiateViewController(withIdentifier: "LicenseView") as! LicenseViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapQuestionsButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "QuestionsView", bundle: nil)
                    
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionsView") as! QuestionsViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tapVersionButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "VersionView", bundle: nil)
                    
        let vc = storyboard.instantiateViewController(withIdentifier: "VersionView") as! VersionViewController

        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapThanksToButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ThanksToView", bundle: nil)
                    
        let vc = storyboard.instantiateViewController(withIdentifier: "ThanksToView") as! ThanksToViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
