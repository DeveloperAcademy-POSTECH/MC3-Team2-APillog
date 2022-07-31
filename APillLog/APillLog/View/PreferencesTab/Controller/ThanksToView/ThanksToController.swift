//
//  ThanksToController.swift
//  APillLog
//
//  Created by 종건 on 2022/07/28.
//

import Foundation
import UIKit

class ThanksToViewController: UIViewController {
  
    @IBOutlet weak var subView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.backgroundColor = UIColor.AColor.background
        
        self.view.backgroundColor = UIColor.AColor.background
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = UIColor.AColor.accent
      
    }
}
