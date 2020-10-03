//
//  Utils.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 25..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    static func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message,preferredStyle: .alert)
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert,animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
    
    func speed() -> String {
        return String(format: "%.1f", self * 3.6) + " km/h"
    }
    
    func km() -> String {
        return String(format: "%.1f", self / 1000) + " km"
    }
    
    func toTime() -> String {
        
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension Notification.Name {
    static let challengeDataUpdate = Notification.Name("challengeDataUpdate")
    static let challangeMapUpdate = Notification.Name("challengeMapUpdate")
}

