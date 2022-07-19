//
//  PrimaryPillDosingCycleChipButton.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/18.
//

import UIKit
 

// MARK: Button Initialization
@IBDesignable
class PrimaryPillDosingCycleChipButton: UIButton {
    @IBInspectable var isInitButton: Bool = false {
        didSet {
            if isInitButton {
                self.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1), for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
