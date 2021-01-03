//
//  HeartRateSensorConnection.swift
//  Challenger
//
//  Created by Andras Sziffer on 2021. 01. 02..
//  Copyright © 2021. Andras Sziffer. All rights reserved.
//

import Foundation

import Foundation
import CoreBluetooth

import UIKit

//MARK:- HeartRateSensorConnectionDelegate
protocol HeartRateSensorConnectionDelegate: class {
    func didStartScan()
    func didConnectToSensor()
}

// MARK:- HeartRateSensorUpdateDelegate
protocol HeartRateSensorUpdateDelegate: class {
    func didUpdateHeartRate(_ bpm: Int, color: UIColor)
}

// MARK:- HearRateSensorConnection Class
class HearRateSensorConnection: NSObject {
    
    /// delegates
    weak var connectionDelegate: HeartRateSensorConnectionDelegate?
    weak var updateDelegate: HeartRateSensorUpdateDelegate?
    
    private var centralManager: CBCentralManager!
    private var heartRatePeripheral: CBPeripheral!
    private var heartRateCharacteristic: CBCharacteristic? = nil
    
    var connected: Bool = false
    
    private let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    private let heartRateSensorLocationCharecteristicCBUUID = CBUUID(string: "2A38")
    private let heartRateSensorMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    
    static let shared = HearRateSensorConnection()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func stop() {
        if heartRateCharacteristic != nil {
            heartRatePeripheral.setNotifyValue(false, for: heartRateCharacteristic!)
        }
    }
    
    func disconnect() {
        centralManager.cancelPeripheralConnection(heartRatePeripheral)
        ChallengeManager.shared.heartRateSensorDidDisConnect()
    }
    
}
// MARK:- CBCentralManagerDelegate
extension HearRateSensorConnection: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
            connectionDelegate?.didStartScan()
            
        @unknown default:
            print("Unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        heartRatePeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(heartRatePeripheral)
        heartRatePeripheral.delegate = self
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
        
    }
}
// MARK:- CBPeripheralDelegate
extension HearRateSensorConnection: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        connected = true
        ChallengeManager.shared.heartRateSensorDidConnect()
        connectionDelegate?.didConnectToSensor()
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                heartRateCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    /// handles received values from hr sensor
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case heartRateSensorLocationCharecteristicCBUUID:
            let _ = bodyLocation(from: characteristic)
        case heartRateSensorMeasurementCharacteristicCBUUID:
            let bpm = heartRate(from: characteristic)
            onHeartRateReceived(bpm)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    /// updates the ui with the new bpm value
    private func onHeartRateReceived(_ bpm: Int) {
        updateDelegate?.didUpdateHeartRate(bpm, color: getColorForBpm(bpm))
    }
    
    /// returns with the location of the heart rate sensor
    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
            let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }
    
    /// calculates the bpm from the byte array
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
    
    private func getColorForBpm(_ bpm: Int) -> UIColor {
        
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
