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
        takingPillButton.tintColor = UIColor.AColor.accent
        takingPillButton.titleLabel?.font = UIFont.AFont.chipText
//        takingPillButton.layer.cornerRadius = 0.5 *  takingPillButton.bounds.size.hei
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
