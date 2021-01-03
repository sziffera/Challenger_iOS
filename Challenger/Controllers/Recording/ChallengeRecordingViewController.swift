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
    @IBOutlet weak var differenceInfoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var rpmLabel: UILabel!
    @IBOutlet weak var heartRatelabel: UILabel!
    @IBOutlet weak var heartRateImageView: UIImageView!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mountainImageView: UIImageView!
    
    ///helper variable to set the pause button text and color
    private var pause: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationTracking.sharedInstance.startTracking()
        
        mountainImageView.tintColor = UIColor(named: K.Color.recording)
        
        /// if it's not a challange, hiding the difference label
        if !ChallengeManager.shared.isChallenge {
            differenceLabel.isHidden = true
            differenceInfoLabel.isHidden = true
        }
        
        stopButton.layer.cornerRadius = 0.5 * stopButton.bounds.size.width
        
        if AppSettings.boolValue(.autoPause) {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        /// setting the delegates to receive updates from sensors
        if ChallengeManager.shared.heartRateSensorConnected {
            HearRateSensorConnection.shared.updateDelegate = self
        }
        if ChallengeManager.shared.cadenceSensorConnected {
            SpeedCadenceSensorConnection.shared.updateDelegate = self
        }
        
    }
    
    
    /// updating the UI based on the received data from LocationTracking
    @objc func challengeDataUpdated(_ notification: NSNotification) {
        
        DispatchQueue.main.async {
            
            guard let data = notification.object as? NSDictionary else { return }
            guard let zeroSpeed = data[K.Notification.zeroSpeed] as? Bool else { return }
            //if the speed is zero, so the auto pause is active, no need to update ui
            if zeroSpeed {
                //reseting the speed, to avoid showing fake values
                DispatchQueue.main.async {
                    self.speedLabel.text = "0 km/h"
                }
                return
            }
            guard let maxSpeed = data[K.Notification.maxSpeed] as? Double else { return }
            guard let myLocation = data[K.Notification.data] as? MyLocation else { return }
            guard let time = data[K.Notification.time] as? Double else { return }
            
            let avgSpeed: Double = myLocation.distance / myLocation.time
            
            self.speedLabel.text = myLocation.speed.speedFromMs()
            self.altitudeLabel.text = myLocation.altitude.format(f: "0") + " m"
            self.durationLabel.text = time.toTime()
            self.distanceLabel.text = myLocation.distance.kmFromMetres()
            self.averageSpeedLabel.text = avgSpeed.speedFromMs()
            self.maxSpeedLabel.text = maxSpeed.speedFromMs()
        }
    }
    
    private func finishRecording() {
        LocationTracking.sharedInstance.finishRecording()
        ChallengeManager.shared.isDiscard = true
        self.performSegue(withIdentifier: K.Segues.finishedRecording, sender: nil)
        if ChallengeManager.shared.cadenceSensorConnected {
            SpeedCadenceSensorConnection.shared.disconnect()
        }
        if ChallengeManager.shared.heartRateSensorConnected {
            HearRateSensorConnection.shared.disconnect()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        finishRecording()
    }
    @IBAction func downStopButtonPressed(_ sender: UIButton) {
        finishRecording()
    }
    @IBAction func pauseButtonPressed(_ sender: UIBarButtonItem) {
        
        if pause {
            pauseButton.title = "Pause"
            pauseButton.tintColor = .orange
            LocationTracking.sharedInstance.startTracking()
        } else {
            pauseButton.title = "Start"
            pauseButton.tintColor = .green
            LocationTracking.sharedInstance.pauseTracking()
        }
        pause = !pause
    }
}

extension ChallengeRecordingViewController: HeartRateSensorUpdateDelegate {
    func didUpdateHeartRate(_ bpm: Int, color: UIColor) {
        heartRatelabel.text = String(bpm)
        heartRatelabel.textColor = color
    }
}

extension ChallengeRecordingViewController: CadenceSensorUpdateDelegate {
    func didUpdateRpm(_ rpm: Double) {
        rpmLabel.text = rpm.rpm()
    }
}
