//
//  File.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/31.
//

import UIKit

class IntrinsicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let number = numberOfRows(inSection: 0)
        var height: CGFloat = 0

        for i in 0..<number {
            guard let cell = cellForRow(at: IndexPath(row: i, section: 0)) else {
                continue
            }
            height += cell.bounds.height
        }
        return CGSize(width: contentSize.width, height: height)
    }
}
