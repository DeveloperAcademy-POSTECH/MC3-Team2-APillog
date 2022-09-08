//
//  Apillog+UINavigationController.swift
//  APillLog
//
//  Created by 이지원 on 2022/09/09.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1 
    }
}
