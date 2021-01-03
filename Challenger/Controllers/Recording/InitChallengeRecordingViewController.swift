//
//  InitChallengeRecordingViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Foundation
class InitChallengeRecordingViewController: UIViewController {

    @IBOutlet weak var backgroundGradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        self.performSegue(withIdentifier: "StartRecordingSettings", sender: nil)
        
    }
}
