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
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
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
        
        let circleImageView = UIImageView(image: UIImage(named: "circle"))
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.AColor.accent.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .range {
            
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            
        } else if selectionType == .start {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                                    cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2,
                                                                        height: self.selectionLayer.frame.width / 2)).cgPath
            
        } else if selectionType == .end {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topRight, .bottomRight],
                                                    cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2,
                                                                        height: self.selectionLayer.frame.width / 2)).cgPath
            
        } else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2,
                                                                   y: self.contentView.frame.height / 2 - diameter / 2,
                                                                   width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.AColor.gray
        }
    }
}
