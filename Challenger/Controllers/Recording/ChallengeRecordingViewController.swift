//
//  ChallengeRecordingViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 17..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class ChallengeRecordingViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationTracking.sharedInstance.startTracking()
        
        NotificationCenter.default.addObserver(self, selector: #selector(challengeDataUpdated(_:)), name: .challengeDataUpdate, object: nil)
        
        
    }
    
    // updating the UI based on the received data from LocationTracking
    @objc func challengeDataUpdated(_ notification: NSNotification) {
        
        guard let data = notification.object as? NSDictionary else { return }
        guard let myLocation = data["data"] as? MyLocation else { return }
        guard let time = data["time"] as? Double else { return }
        
        let avgSpeed: Double = myLocation.time / myLocation.distance
        DispatchQueue.main.async {
            self.speedLabel.text = myLocation.speed.speed()
            self.altitudeLabel.text = myLocation.altitude.format(f: "0")
            self.durationLabel.text = time.toTime()
            self.distanceLabel.text = myLocation.distance.km()
            self.averageSpeedLabel.text = avgSpeed.speed()
        }
    }
}
