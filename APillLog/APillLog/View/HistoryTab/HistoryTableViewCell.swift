//
//  HistoryTableViewCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/18.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // 라벨링뷰
    @IBOutlet weak var pillLabelView: UIView!
    @IBOutlet weak var sideEffectLabelView: UIView!
    @IBOutlet weak var detailContextLabelView: UIView!

    // 사용자의 정보가 담길 변수
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var pillName: UILabel!
    @IBOutlet weak var sideEffect: UILabel!
    @IBOutlet weak var detailContext: UILabel!
    
    // 라발렝 뷰 + UILabel이 담긴 Horizonal StackView (ex. 약 복용 + 콘서타18mg)
    @IBOutlet weak var stackViewPillName: UIStackView!
    @IBOutlet weak var stackViewSideEffect: UIStackView!
    @IBOutlet weak var stackViewDetailContext: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
