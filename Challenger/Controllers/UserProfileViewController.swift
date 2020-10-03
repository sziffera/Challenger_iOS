//
//  UserProfileViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameTextView: UILabel!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    let defaults = UserDefaults.standard
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        if let currentUserId = Auth.auth().currentUser?.uid {
            
            
            if let username = AppSettings.stringValue(.username) {
                self.navigationItem.title = "Hi \(username)!"
            } else {
                self.ref.child("users").child(currentUserId).child("username").observeSingleEvent(of: .value) { (snapshot) in
                    let username = snapshot.value as? String
                    AppSettings[.username] = username
                    self.navigationItem.title = "Hi \(username ?? "Hi")!"
                }
            }
        }
        let logOutButton = UIBarButtonItem(title: "Log-out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonPressed(sender:)))
        logOutButton.tintColor = UIColor(named: K.Color.darkBlue)
        self.navigationItem.rightBarButtonItem = logOutButton
        
        
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingsButtonPressed(sender:)))
        settingsButton.tintColor = UIColor(named: K.Color.darkBlue)
        self.navigationItem.leftBarButtonItem = settingsButton
        
    }
    
    @objc func logOutButtonPressed(sender: UIBarButtonItem) {
        do {
            try
                Auth.auth().signOut()
            AppSettings[.username] = nil
            self.performSegue(withIdentifier: K.Segues.signOut, sender: nil)
            
        } catch {
            print("already logged out")
        }
    }
    @objc func settingsButtonPressed(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.Segues.startSettingsFromProfile, sender: nil)
    }
    
}
