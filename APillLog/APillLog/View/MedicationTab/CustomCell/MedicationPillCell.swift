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
        setButtonStyle()
        // Initialization code
    }

    func setButtonStyle(){
        takingPillButton.setTitle("복용", for: .normal)
        takingPillButton.titleLabel?.font = UIFont.AFont.buttonText
        takingPillButton.setTitleColor(UIColor.AColor.white, for: .normal)
        takingPillButton.layer.borderWidth = 1
        takingPillButton.layer.borderColor = UIColor.AColor.accent.cgColor
        takingPillButton.tintColor = UIColor.AColor.accent
    }

    func changeTakingPillButtonState(_ button: UIButton) {
        if button.isSelected {
            button.setTitle("✓", for: .selected)
            button.setTitleColor(UIColor.AColor.gray, for: .selected)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.gray.cgColor
            button.tintColor = UIColor.AColor.white
        } else {
            button.setTitle("복용", for: .normal)
            button.setTitleColor(UIColor.AColor.white, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.AColor.accent.cgColor
            button.tintColor = UIColor.AColor.accent
        }
    }

    @IBAction func tapTakingPillButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeTakingPillButtonState(sender)
        if sender.isSelected {
            delegate?.setPillTake(rowNumber: rowNumber, isPrimary: isPrimary)
        } else {
            // TODO : 히스토리에 넣은 약을 제거하는 기능 필요
            delegate?.setPillNotTake(rowNumber: rowNumber, isPrimary: isPrimary)
        }
    }
}



