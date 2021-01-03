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

class HearRateSensorConnection: NSObject {
    
    private var centralManager: CBCentralManager!
    private var heartRatePeripheral: CBPeripheral!
    private var heartRateCharacteristic: CBCharacteristic? = nil
    
    var connected: Bool = false
    
    var label: UILabel? = nil
    var viewController: UIViewController!
    
    private let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    private let heartRateSensorLocationCharecteristicCBUUID = CBUUID(string: "0x2A5D")
    private let heartRateSensorMeasurmentCharacteristicCBUUID = CBUUID(string: "0x2A5B")
    
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
    
}

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
        print("connected")
        Utils.showToast(controller: viewController, message: "Heart Rate sensor successfully connected!", seconds: 2)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
        
    }
}

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
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case heartRateSensorLocationCharecteristicCBUUID:
            print(characteristic.value ?? "no value")
        case heartRateSensorMeasurmentCharacteristicCBUUID:
            decodeCSC(from: characteristic)
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}
