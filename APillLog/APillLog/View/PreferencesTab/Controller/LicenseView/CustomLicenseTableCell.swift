//
//  CustomLicenseTableCell.swift
//  APillLog
//
//  Created by 종건 on 2022/07/31.
//

import Foundation

import UIKit

class CustomLicenseTableCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellArrow: UILabel!
    var cellUUID: UUID = UUID()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
