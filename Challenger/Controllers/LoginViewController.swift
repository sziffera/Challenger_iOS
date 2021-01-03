//
//  ViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 07..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private let mAuth: FirebaseAuth.User? = Auth.auth().currentUser
    private let generator = UINotificationFeedbackGenerator()
    private var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        emailAddressTextField.delegate = self
        
        signInButton.layer.cornerRadius = 5
     
        //gradient background
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        signInUser()
    }
    
    private func signInUser() {
        view.endEditing(true)
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.generator.notificationOccurred(.error)
                    Utils.showToast(controller: self, message: e.localizedDescription, seconds: 3)
                    print(e)
                    print(e.localizedDescription)
                } else {
                    
                    if let currentUserId = Auth.auth().currentUser?.uid {
                        self.ref.child("users").child(currentUserId).child("username").observeSingleEvent(of: .value) { (snapshot) in
                            let username = snapshot.value as? String
                            AppSettings[.username] = username
                        }
                    }
                    self.generator.notificationOccurred(.success)
                    self.performSegue(withIdentifier: "StartMainScreen", sender: nil)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInUser()
        return true
    }
    
}

