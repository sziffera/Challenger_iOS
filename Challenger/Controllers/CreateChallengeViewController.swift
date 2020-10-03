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
        self.performSegue(withIdentifier: "StartSettingsFromCreate", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
