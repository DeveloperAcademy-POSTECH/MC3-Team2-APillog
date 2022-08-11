//
//  DIYCalendarCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/08/11.
//

import UIKit
import FSCalendar

enum SelectionType: Int {
    case none
    case single
    case start
    case end
    case range
}

class DIYCalendarCell: FSCalendarCell {
    
    weak var selcetionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if selectionType == .range {
            
        }
    }
}
