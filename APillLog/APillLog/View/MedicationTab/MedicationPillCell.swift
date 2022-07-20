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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
