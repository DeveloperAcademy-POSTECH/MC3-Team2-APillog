//
//  HistoryTableViewCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/18.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // 사용자의 정보가 담길 변수
    @IBOutlet var createTime: UILabel!
    @IBOutlet var pillName: UILabel!
    @IBOutlet var sideEffect: UILabel!
    @IBOutlet var medicinalEffect: UILabel!
    @IBOutlet var detailContext: UILabel!
    
    // UILabel이 담긴 StackView (ex. 약 복용 + 콘서타18mg)
    @IBOutlet var stackViewPillName: UIStackView!
    @IBOutlet var stackViewSideEffect: UIStackView!
    @IBOutlet var stackViewMedicinalEffect: UIStackView!
    @IBOutlet var stackViewDetailContext: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
