//
//  RegisterViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 08..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var createAnAccountButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAnAccountButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView?.tintColor = .white
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func createAnAccountButtonPressed(_ sender: UIButton) {
        
        let generator = UINotificationFeedbackGenerator()
        
        
        if let emailAddress = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
            
            if !Utils.isValidEmail(emailAddress) {
                generator.notificationOccurred(.error)
                Utils.showToast(controller: self, message: "Please provide a valid email address", seconds: 2)
                return
            }
            if password.count < 6 {
                generator.notificationOccurred(.error)
                Utils.showToast(controller: self, message: "The password must be at least 6 characters", seconds: 2)
                return
            }
            
            Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
                if let e = error {
                    Utils.showToast(controller: self, message: e.localizedDescription, seconds: 2)
                    generator.notificationOccurred(.error)
                    return
                } else {
                    let ref = Database.database().reference()
                    if let userId = Auth.auth().currentUser?.uid {
                        print("the user id is: \(userId)")
                        let user = ["username": username,
                                    "email": emailAddress]
                        ref.child("users").child(userId).setValue(user) { (error, ref) in
                            if let e = error {
                                print("There was an error: \(e)")
                            } else {
                                print("Write was successful for ref: \(ref)")
                            }
                        }
                        generator.notificationOccurred(.success)
                        self.performSegue(withIdentifier: K.Segues.startMainAfterRegister, sender: nil)
                    }
                }
            }
            
        } else {
            Utils.showToast(controller: self, message: "Please fill the required fields", seconds: 2)
            generator.notificationOccurred(.error)
        }
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
