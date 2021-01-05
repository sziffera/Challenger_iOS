//
//  BluetoothConnectionViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 10. 11..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothConnectionViewController: UIViewController {
    
    private var cBCentralManager: CBCentralManager!

    @IBOutlet weak var heartRateLoader: UIActivityIndicatorView!
    @IBOutlet weak var cadenceLoader: UIActivityIndicatorView!
    @IBOutlet weak var heartRateConnectionButton: UIButton!
    @IBOutlet weak var cadenceSensorConnectionButton: UIButton!
    @IBOutlet weak var cadenceSensorInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cBCentralManager = CBCentralManager()
        cBCentralManager.delegate = self
        
        /// init ui
        heartRateConnectionButton.layer.cornerRadius = 5
        cadenceSensorConnectionButton.layer.cornerRadius = 5
        heartRateLoader.stopAnimating()
        cadenceLoader.stopAnimating()
        cadenceSensorInfoLabel.isHidden = true
        
        /// setting the connection delegates to get notification about connection state
        SpeedCadenceSensorConnection.shared.cadenceSensorConnectionDelegate = self
        HearRateSensorConnection.shared.connectionDelegate = self

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ChallengeManager.shared.cadenceSensorConnected {
            setCadenceButton(state: .connected)
        }
        
        if ChallengeManager.shared.heartRateSensorConnected {
            setHeartRateButton(state: .connected)
        }
    }
    
    @IBAction func heartRateConnectionButtonPressed(_ sender: UIButton) {
        if ChallengeManager.shared.heartRateSensorConnected {
            return
        }
        HearRateSensorConnection.shared.startScan()
        setHeartRateButton(state: .scan)
    }
    
    @IBAction func cadenceSensorConnectionButtonPressed(_ sender: UIButton) {
        if ChallengeManager.shared.cadenceSensorConnected {
            return
        }
        SpeedCadenceSensorConnection.shared.startScan()
        setCadenceButton(state: .scan)
    }
    
    private func setCadenceButton(state: ConnectionStates) {
        switch state {
        case .notConnected:
            cadenceSensorConnectionButton.isEnabled = true
            cadenceSensorConnectionButton.setTitle("Connect to Cadence Sensor", for: .normal)
            cadenceSensorConnectionButton.setTitleColor(UIColor(named: K.Color.darkBlue), for: .normal)
            cadenceLoader.stopAnimating()
            cadenceSensorInfoLabel.isHidden = true
        case .connected:
            cadenceSensorConnectionButton.isEnabled = false
            cadenceSensorConnectionButton.setTitle("Cadence Sensor Connected!", for: .normal)
            cadenceSensorConnectionButton.setTitleColor(.green, for: .normal)
        case .scan:
            cadenceSensorConnectionButton.setTitle("Scanning for Cadence Sensor...", for: .normal)
            cadenceLoader.startAnimating()
            cadenceSensorConnectionButton.isEnabled = false
            cadenceSensorInfoLabel.isHidden = false
        }
    }
    
    private func setHeartRateButton(state: ConnectionStates) {
        switch state {
        case .notConnected:
            heartRateConnectionButton.isEnabled = true
            heartRateConnectionButton.setTitle("Connect to Heart Rate Sensor", for: .normal)
            heartRateConnectionButton.setTitleColor(UIColor(named: K.Color.darkBlue), for: .normal)
            heartRateLoader.stopAnimating()
        case .connected:
            heartRateConnectionButton.isEnabled = false
            heartRateConnectionButton.setTitle("Heart Rate Sensor Connected!", for: .normal)
            heartRateConnectionButton.setTitleColor(.green, for: .normal)
        case .scan:
            heartRateConnectionButton.setTitle("Scanning for Heart Rate Sensor...", for: .normal)
            heartRateLoader.startAnimating()
            heartRateConnectionButton.isEnabled = false
        }
    }
    
    
    private enum ConnectionStates {
        case notConnected
        case scan
        case connected
    }
}

//MARK:- CadenceSensorConnectionDelegate

extension BluetoothConnectionViewController: CadenceSensorConnectionDelegate {
    
    func cadenceSensorScanTimeout() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        Utils.showToast(controller: self, message: "Connection timeout. Make sure your sensor is turned on and try again.", seconds: 3)
        setCadenceButton(state: .notConnected)
    }
    
    func didStartCadenceSensorScan() {
        setCadenceButton(state: .scan)
    }
    
    func didConnectToCadenceSensor() {
        print("connected")
        Utils.showToast(controller: self, message: "Cadence sensor successfully connected!", seconds: 2)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        cadenceLoader.stopAnimating()
        cadenceSensorConnectionButton.setTitle("Cadence Sensor Connected!", for: .normal)
        cadenceSensorConnectionButton.setTitleColor(.green, for: .normal)
        cadenceSensorInfoLabel.isHidden = true
    }
    
}

//MARK:- HeartRateSensorConnectionDelegate

extension BluetoothConnectionViewController: HeartRateSensorConnectionDelegate {
    func heartRateSensorScanTimeout() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        Utils.showToast(controller: self, message: "Connection timeout. Make sure your sensor is turned on and try again.", seconds: 3)
        setHeartRateButton(state: .notConnected)
    }
    
    func didStartScan() {
        setHeartRateButton(state: .scan)
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

//MARK:- CBCentralManagerDelegate

extension BluetoothConnectionViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            setButtonState(enabled: true)
            break
        case .poweredOff:
            setButtonState(enabled: false)
            Utils.showToast(controller: self, message: "Please turn on Bluetooth to scan for sensors", seconds: 2)
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            Utils.showToast(controller: self, message: "The BLE connection is not supported!", seconds: 2)
            setButtonState(enabled: false)
            break
        case .unknown:
            Utils.showToast(controller: self, message: "An error occured", seconds: 2)
            setButtonState(enabled: false)
            break
        default:
            break
        }
    }
    
    private func setButtonState(enabled: Bool) {
        cadenceSensorConnectionButton.isEnabled = enabled
        heartRateConnectionButton.isEnabled = enabled
    }
}
