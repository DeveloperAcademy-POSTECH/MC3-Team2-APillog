//
//  PreferencesViewCell.swift
//  APillLog
//
//  Created by 종건 on 2022/07/27.
//

import UIKit

class PreferencesCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var arrow: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
