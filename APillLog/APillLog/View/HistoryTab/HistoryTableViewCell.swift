//
//  HistoryTableViewCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/18.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // 사용자의 정보가 담길 변수
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var pillName: UILabel!
    @IBOutlet weak var sideEffect: UILabel!
    @IBOutlet weak var medicinalEffect: UILabel!
    @IBOutlet weak var detailContext: UILabel!
    
    // UILabel이 담긴 StackView (ex. 약 복용 + 콘서타18mg)
    @IBOutlet weak var stackViewPillName: UIStackView!
    @IBOutlet weak var stackViewSideEffect: UIStackView!
    @IBOutlet weak var stackViewMedicinalEffect: UIStackView!
    @IBOutlet weak var stackViewDetailContext: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func HistoryTableViewCellStyle() {
//        self.createdTime.font = UIFont.AFont.historyCategyry
//    }
//    
}
