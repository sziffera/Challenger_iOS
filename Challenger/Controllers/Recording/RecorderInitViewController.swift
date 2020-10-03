//
//  RecorderSettingsViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 20..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class RecorderInitViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setting the settings button in NavBar
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingsButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = settingsButton
        
        //setting the cancel button in NavBar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        //making the NavBar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    @objc func cancelButtonPressed(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CancelRecorderSettings", sender: nil)
    }
    
    @objc func settingsButtonPressed(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "OpenDetailedSettings", sender: nil)
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "StartRecording", sender: nil)
    }
}
