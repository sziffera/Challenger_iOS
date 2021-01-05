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
    static func getColorForBpm(_ bpm: Int) -> UIColor {
        switch bpm {
        case 98...116:
            return UIColor(named: K.Color.moderate)!
        case 117...136:
            return UIColor(named: K.Color.weightControl)!
        case 137...155:
            return UIColor(named: K.Color.aerobic)!
        case 156...175:
            return UIColor(named: K.Color.anaerobic)!
        case 176...195:
            return UIColor(named: K.Color.vo2max)!
        default:
            return UIColor(named: K.Color.recording)!
        }
    }
}
// MARK:- Extensions for Double class
extension Double {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
    
    func speedFromMs() -> String {
        let speed = self * 3.6
        if speed <= 0 {
            return "0.0 km/h"
        } else {
            return String(format: "%.1f", speed) + " km/h"
        }
    }
    
    func speed() -> String {
        return String(format: "%.1f", self) + " km/h"
    }
    
    func kmFromMetres() -> String {
        return String(format: "%.2f", self / 1000) + " km"
    }
    
    func km() -> String {
        return String(format: "%.2f", self) + " km"
    }
    
    func rpm() -> String {
        return String(format: "%.0f", self) + " RPM"
    }
    
    func toTime() -> String {
        if self.isNaN || self.isInfinite {
            return "NaN"
        }
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func toPace() -> String {
        if self.isNaN || self.isInfinite {
            return "NaN"
        }
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
// MARK:-Notification
extension Notification.Name {
    static let challengeDataUpdate = Notification.Name("challengeDataUpdate")
    static let challangeMapUpdate = Notification.Name("challengeMapUpdate")
    static let cadenceDataUpdated =
        Notification.Name("cadenceDataUpdated")
    static let hearRateDataUpdated = Notification.Name("heartRateDataUpdated")
    
}
// MARK:-Moving Average
struct MovingAverage {
  var period: Int
  var numbers = [Double]()
 
  mutating func addNumber(_ n: Double) -> Double {
    numbers.append(n)
 
    if numbers.count > period {
      numbers.removeFirst()
    }
 
    guard !numbers.isEmpty else {
      return 0
    }
 
    return numbers.reduce(0, +) / Double(numbers.count)
  }
}
