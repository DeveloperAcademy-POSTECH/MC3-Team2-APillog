//
//  MedicationPillCell.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/21.
//

import UIKit

protocol TakeMedicationDelegate {
    func setPillTake(rowNumber: Int, isPrimary: Bool)
    func setPillNotTake(rowNumber: Int, isPrimary: Bool)
}

class MedicationPillCell: UITableViewCell {
    @IBOutlet weak var pillImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var takingPillButton: UIButton!

    var rowNumber: Int = 0
    var isPrimary: Bool = false
    var delegate: TakeMedicationDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func changeTakingPillButtonState(_ button: UIButton) {
        if button.isSelected {
            button.setTitle("✓", for: .selected)
            button.titleLabel?.font = UIFont.AFont.buttonTitle
            button.setTitleColor(UIColor.AColor.gray, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.gray.cgColor
            button.layer.backgroundColor = UIColor.AColor.white.cgColor
            button.tintColor = UIColor.AColor.white
            
            
        } else {
            button.setTitle("복용", for: .normal)
            button.titleLabel?.font = UIFont.AFont.buttonText
            button.setTitleColor(UIColor.AColor.white, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.accent.cgColor
            button.layer.backgroundColor = UIColor.AColor.accent.cgColor
            button.tintColor = UIColor.AColor.accent
        }
    }

    @IBAction func tapTakingPillButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeTakingPillButtonState(sender)
        if sender.isSelected {
            delegate?.setPillTake(rowNumber: rowNumber, isPrimary: isPrimary)
        } else {
            delegate?.setPillNotTake(rowNumber: rowNumber, isPrimary: isPrimary)
        }
    }
}



