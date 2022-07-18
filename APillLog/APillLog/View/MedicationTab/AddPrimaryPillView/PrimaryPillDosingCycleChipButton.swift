//
//  PrimaryPillDosingCycleChipButton.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/18.
//

import UIKit

@IBDesignable
class PrimaryPillDosingCycleChipButton: UIButton {
    @IBInspectable var isChip: Bool = false {
        didSet {
            if isChip {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
