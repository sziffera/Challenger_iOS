//
//  InitialViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 17..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "StartMainScreen", sender: nil)
            }
        else {
            self.performSegue(withIdentifier: "StartLoginScreen", sender: nil)
        }
    }
  
}
