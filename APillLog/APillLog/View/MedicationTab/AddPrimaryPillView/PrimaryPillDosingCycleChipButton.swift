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
                self.setTitleColor(UIColor.AColor.gray, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.AColor.textFieldBorder.cgColor
                self.layer.cornerRadius = self.frame.height / 2
                self.titleLabel?.font = UIFont.AFont.buttonText
            }
        }
    }
}
