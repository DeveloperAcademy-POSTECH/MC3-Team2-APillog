//
//  HistoryDetailProgressViewCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import UIKit

class HistoryDetailProgressViewCell: UITableViewCell {
    
    @IBOutlet weak var pillName: UILabel!
    @IBOutlet weak var pillDosage: UIProgressView!
    @IBOutlet weak var pillRatio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
