//
//  MedicationPillCell.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/21.
//

import UIKit

class MedicationPillCell: UITableViewCell {
    @IBOutlet weak var pillImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var pillTimeLabel: UILabel!
    @IBOutlet weak var editPillTimeButton: UIButton!
    @IBOutlet weak var takingPillButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonStyle()
        // Initialization code
    }

    func setButtonStyle(){
        takingPillButton.setTitle("복용", for: .normal)
        takingPillButton.titleLabel?.font = UIFont.AFont.chipText
        takingPillButton.setTitleColor(UIColor.AColor.white, for: .normal)
        takingPillButton.layer.borderWidth = 1
        takingPillButton.layer.borderColor = UIColor.AColor.accent.cgColor
        takingPillButton.tintColor = UIColor.AColor.accent
    }

    func changeTakingPillButtonState(_ button: UIButton) {
        if button.isSelected {
            button.setTitle("✓", for: .selected)
            button.titleLabel?.font = UIFont.AFont.chipText
            button.setTitleColor(UIColor.AColor.gray, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.gray.cgColor
            button.tintColor = UIColor.AColor.white
        } else {
            button.setTitle("복용", for: .normal)
            button.titleLabel?.font = UIFont.AFont.chipText
            button.setTitleColor(UIColor.AColor.white, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.accent.cgColor
            button.tintColor = UIColor.AColor.accent
        }
    }

    @IBAction func tapTakingPillButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeTakingPillButtonState(sender)
    }
}
