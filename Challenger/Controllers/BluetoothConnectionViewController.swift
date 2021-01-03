//
//  BluetoothConnectionViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 10. 11..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class BluetoothConnectionViewController: UIViewController {

    @IBOutlet weak var heartRateLoader: UIActivityIndicatorView!
    @IBOutlet weak var cadenceLoader: UIActivityIndicatorView!
    @IBOutlet weak var heartRateConnectionButton: UIButton!
    @IBOutlet weak var cadenceSensorConnectionButton: UIButton!
    @IBOutlet weak var cadenceSensorInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heartRateConnectionButton.layer.cornerRadius = 5
        cadenceSensorConnectionButton.layer.cornerRadius = 5
        heartRateLoader.stopAnimating()
        cadenceLoader.stopAnimating()
        cadenceSensorInfoLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ChallengeManager.shared.cadenceSensorConnected {
            cadenceSensorConnectionButton.isEnabled = false
            cadenceSensorConnectionButton.setTitle("Cadence Sensor Connected!", for: .normal)
            cadenceSensorConnectionButton.setTitleColor(.green, for: .normal)
        }
        
        if ChallengeManager.shared.heartRateSensorConnected {
            heartRateConnectionButton.isEnabled = false
            heartRateConnectionButton.setTitle("Cadence Sensor Connected!", for: .normal)
            heartRateConnectionButton.setTitleColor(.green, for: .normal)
        }
    }
    
    @IBAction func heartRateConnectionButtonPressed(_ sender: UIButton) {
        heartRateLoader.startAnimating()
        heartRateConnectionButton.isEnabled = false
        HearRateSensorConnection.shared.connectionDelegate = self
    }
    
    @IBAction func cadenceSensorConnectionButtonPressed(_ sender: UIButton) {
        cadenceLoader.startAnimating()
        cadenceSensorConnectionButton.isEnabled = false
        SpeedCadenceSensorConnection.shared.connectionDelegate = self
        cadenceSensorInfoLabel.isHidden = false
    }
    
}

extension BluetoothConnectionViewController: CadenceSensorConnectionDelegate {
    func didStartCadenceSensorScan() {
        cadenceSensorConnectionButton.setTitle("Scanning for Cadence Sensor...", for: .normal)
    }
    
    func didConnectToCadenceSensor() {
        print("connected")
        Utils.showToast(controller: self, message: "Cadence sensor successfully connected!", seconds: 2)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        cadenceLoader.stopAnimating()
        cadenceSensorConnectionButton.setTitle("Cadence Sensor Connected!", for: .normal)
        cadenceSensorConnectionButton.setTitleColor(.green, for: .normal)
    }
}

extension BluetoothConnectionViewController: HeartRateSensorConnectionDelegate {
    func didStartScan() {
        heartRateConnectionButton.setTitle("Scanning for Heart Rate Sensor...", for: .normal)
    }
    
    func didConnectToSensor() {
        print("connected")
        Utils.showToast(controller: self, message: "Heart Rate sensor successfully connected!", seconds: 2)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        heartRateLoader.stopAnimating()
        heartRateConnectionButton.setTitle("Heart Rate Sensor Connected!", for: .normal)
        heartRateConnectionButton.setTitleColor(.green, for: .normal)
    }
}
