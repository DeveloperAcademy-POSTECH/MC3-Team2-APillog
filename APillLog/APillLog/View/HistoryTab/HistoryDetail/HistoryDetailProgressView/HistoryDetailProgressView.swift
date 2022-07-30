//
//  HistoryDetailProgressView.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import UIKit

@IBDesignable
class HistoryDetailProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("HistoryDetailProgressView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    
}
