//
//  IndoorTrainingViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 10. 31..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class IndoorTrainingViewController: UIViewController {
    
    @IBOutlet weak var rpmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cadanceDataUpdated(_:)), name: .cadenceDataUpdated, object: nil)
        
    }
    
    @objc func cadanceDataUpdated(_ notification: NSNotification) {
        
        guard let rpm = notification.object as? Double else { return }
        
        DispatchQueue.main.async {
            self.rpmLabel.text = rpm.rpm()
        }
        
    }
    
}
