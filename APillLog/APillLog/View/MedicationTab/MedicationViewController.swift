//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController, AddSecondaryPillViewControllerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var addedSecondaryPillName: UILabel!
    
    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    // MARK: AddSecondaryPillViewControllerDelegate
    func modalDidFinished(selectedPill: String) {
        addedSecondaryPillName.text = selectedPill
    }
}
