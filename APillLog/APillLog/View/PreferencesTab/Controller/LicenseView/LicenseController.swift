//
//  LicenseController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/28.
//

import Foundation
import UIKit

class LicenseViewController: UIViewController {
    
    @IBOutlet weak var fsButton: UIButton!
    @IBOutlet weak var chartsButton: UIButton!
    @IBOutlet weak var licenseTitle: UILabel!
    
    @IBAction func tapFSButton(){
        let storyboard = UIStoryboard(name: "FSLicenseView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "fsLicenseView") as! FSLicenseViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapChartsButton(){
        let storyboard = UIStoryboard(name: "ChartsLicenseView", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "ChartsLicenseView") as! ChartsLicenseViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.AColor.background
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
        self.navigationController?.title = "설정"
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.fsButton.layer.cornerRadius = 14
        self.chartsButton.layer.cornerRadius = 14
        self.licenseTitle.font = UIFont.AFont.navigationTitle
    }
}
