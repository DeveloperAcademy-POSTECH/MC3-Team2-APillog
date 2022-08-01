//
//  ChartsLicenseViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/31.
//

import UIKit
class ChartsLicenseViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Charts"
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
    }
}
