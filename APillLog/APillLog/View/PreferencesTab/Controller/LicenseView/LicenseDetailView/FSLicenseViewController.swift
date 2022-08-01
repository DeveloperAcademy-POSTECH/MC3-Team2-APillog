//
//  FSLicenseViewController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/31.
//

import UIKit
class FSLicenseViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "FSCalendar"
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
    }
}
