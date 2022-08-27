//
//  OnboardingCollectionViewCell.swift
//  APillLog
//
//  Created by 이지원 on 2022/08/13.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingDescription: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    
    var slides: [OnboardingSlide] = []
    
    func setup(_ slide: OnboardingSlide) {
        onboardingImage.image = slide.image
        onboardingTitle.text = slide.title
        onboardingDescription.text = slide.description
    }
    
}
