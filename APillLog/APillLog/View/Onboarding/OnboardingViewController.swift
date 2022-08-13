//
//  OnboardingViewController.swift
//  APillLog
//
//  Created by 이지원 on 2022/08/13.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                startButton.isHidden = false
            } else {
                startButton.isHidden = true
            }
        }
    }
    
    var slides = [
        OnboardingSlide(title: "Page1", description: "description1", image: UIImage(systemName: "photo")!),
        OnboardingSlide(title: "Page2", description: "description2", image: UIImage(systemName: "photo")!),
        OnboardingSlide(title: "Page3", description: "description3", image: UIImage(systemName: "photo")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = true
    }
    
    
    @IBAction func didTapStartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
        
        UserDefaults.standard.set("No", forKey: "isFirstTime")
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

public class Storage {
    static func isFirstTime() -> Bool {
        UserDefaults.standard.object(forKey: "isFirstTime") == nil
    }
}
