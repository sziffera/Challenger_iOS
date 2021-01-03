//
//  CreateChallengeViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class CreateChallengeViewController: UIViewController {

    @IBOutlet weak var startChallengeButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var backgroundGradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        startChallengeButton.layer.cornerRadius = 5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        timePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    
    @IBAction func startChallengeButtonPressed(_ sender: UIButton) {
        // TODO: not completed
        ChallengeManager.shared.isChallenge = true
        self.performSegue(withIdentifier: "StartSettingsFromCreate", sender: nil)
    }
}
