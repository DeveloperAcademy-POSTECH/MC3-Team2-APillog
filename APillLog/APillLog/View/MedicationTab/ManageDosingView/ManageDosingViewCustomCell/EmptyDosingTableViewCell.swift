//
//  EmptyDosingTableViewCell.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/28.
//

import UIKit

class EmptyDosingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emptyDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
