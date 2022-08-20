//
//  ConditionChipButton.swift
//  APillLog
//
//  Created by 이영준 on 2022/08/11.
//

import UIKit

@IBDesignable
class ConditionChipButton: UIButton {
    @IBInspectable var isInitConditionButton: Bool = false {
        didSet {
            if isInitConditionButton {
                self.setTitleColor(UIColor.AColor.gray, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.AColor.disable.cgColor
                self.layer.cornerRadius = self.frame.height / 2
                self.titleLabel?.font = UIFont.AFont.chipText
            }
        }
    }
}
