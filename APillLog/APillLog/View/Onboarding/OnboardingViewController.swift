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
    @IBOutlet weak var lastPageStackView: UIImageView!
    @IBOutlet weak var lastPageImageView: UIImageView!
    
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                lastPageStackView.isHidden = false
                startButton.isHidden = false
            } else {
                if currentPage == 4 {
                    AppDelegate.center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                        if let e = error {
                            print("Error = \(e)")
                        }
                    }
                }
                lastPageStackView.isHidden = true
                startButton.isHidden = true
            }
        }
    }
    
    var slides = [
        OnboardingSlide(title: "간편한 약 등록",
                        description: "매일 먹어야하는 약을 등록하고 손쉽게 기록하세요",
                        image: UIImage(named: "onboarding1")!),
        OnboardingSlide(title: "데일리 부작용 입력",
                        description: "불편함, 부작용을 기록해보세요\n 정보는 히스토리 탭에서 볼 수 있어요",
                        image: UIImage(named: "onboarding2")!),
        OnboardingSlide(title: "직관적인 기록 확인",
                        description: "리포트 화면에서\n모든 기록을 한 번에 확인해보세요",
                        image: UIImage(named: "onboarding3")!),
        OnboardingSlide(title: "자가 인지 행동 치료",
                        description: "에필로그를 통해 CBT를 진행해보세요\n당신의 잘못이 아니라는 사실, 잊지 마세요",
                        image: UIImage(named: "onboarding4")!),
        OnboardingSlide(title: "복약 시간 알림",
                        description: "알림 권한을 허용해주시면\n에필로그가 약 먹을 시간을 알려드려요",
                        image: UIImage(named: "onboarding5")!),
        OnboardingSlide(title: "",
                        description: "",
                        image: UIImage())
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = true
        lastPageStackView.isHidden = true
        lastPageImageView.image = UIImage(named: "onboarding6")
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
