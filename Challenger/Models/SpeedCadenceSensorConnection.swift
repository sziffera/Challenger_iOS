//
//  CadenceSensorConnection.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 10. 08..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import CoreBluetooth

import UIKit

class SpeedCadenceSensorConnection: NSObject {
    
    private var centralManager: CBCentralManager!
    private var cadencePeripheral: CBPeripheral!
    private var cadenceCharacteristic: CBCharacteristic? = nil
    
    var connected: Bool = false
    
    var label: UILabel? = nil
    var viewController: UIViewController!
    
    private var rpm = 0.0
    private var uiRpm = 0.0
    private var prevCrankStaleness = 0.0
    private var prevCumCrankRev = 0
    private var prevCrankTime = 0
    private var prevRPM = 0.0
    
    private let cadenceServiceCBUUID = CBUUID(string: "0x1816")
    private let cadenceSensorLocationCharecteristicCBUUID = CBUUID(string: "0x2A5D")
    private let cadenceSensorMeasurmentCharacteristicCBUUID = CBUUID(string: "0x2A5B")
    
    static let shared = SpeedCadenceSensorConnection()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func stop() {
        if cadenceCharacteristic != nil {
            cadencePeripheral.setNotifyValue(false, for: cadenceCharacteristic!)
        }
    }
    
}

extension SpeedCadenceSensorConnection: CBCentralManagerDelegate {
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
            
            centralManager.scanForPeripherals(withServices: [cadenceServiceCBUUID])
            
        @unknown default:
            print("Unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        cadencePeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(cadencePeripheral)
        cadencePeripheral.delegate = self
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        Utils.showToast(controller: viewController, message: "Cadence sensor successfully connected!", seconds: 2)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        cadencePeripheral.discoverServices([cadenceServiceCBUUID])
        
    }
}

extension SpeedCadenceSensorConnection: CBPeripheralDelegate {
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
        ChallengeManager.shared.cadenceSensorDidConnect()
        
        for characteristic in characteristics {
            print(characteristic)
        
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                cadenceCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case cadenceSensorLocationCharecteristicCBUUID:
            print(characteristic.value ?? "no value")
        case cadenceSensorMeasurmentCharacteristicCBUUID:
            let _ = decodeCSC(from: characteristic)
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func decodeCSC(from characteristic: CBCharacteristic) -> Int {
        
        /*
         
         guard let characteristicData = characteristic.value else { return -1 }
         
         
         
         let value = [UInt8](characteristicData)
         var offset = 1
         let flag = value[0]
         let hasWheelData = (flag & 0x01) > 0
         let hasCrankData = (flag & 0x02) > 0
         
         if hasWheelData {
         let newTotalWheelRevolutions = Int(UInt16(value[offset]))
         offset += 4
         
         let wheelTime = Double(UInt16(value[offset]))
         offset += 2
         
         
         let newWheelRevolutions = newTotalWheelRevolutions - totalWheelRevolutions
         totalWheelRevolutions = newTotalWheelRevolutions
         
         let distance = Double(newWheelRevolutions) * wheelDiameter * Double.pi / 1000.0
         
         if (wheelTime != 0) {
         let wheelTimeInSeconds = wheelTime / 1024.0
         
         // 3.6 = convert from m/s to km/h
         let speed = (distance / wheelTimeInSeconds) // in m/s
         print(speed.speed())
         }
         }
         
         if hasCrankData {
         let newTotalCrankRevolutions = Int(UInt16(value[offset]))
         offset += 2
         
         let crankTime = Int(UInt16(value[offset]))
         
         let newCrankRevolutions = newTotalCrankRevolutions - totalCrankRevolutions
         totalCrankRevolutions = newTotalCrankRevolutions
         
         if (crankTime != 0) {
         let crankTimeInSeconds = Double(crankTime) / 1024.0
         let rpm = Double(newCrankRevolutions) / crankTimeInSeconds
         print("The rpm is: \(rpm)")
         }
         }
         
         return -1
         */
        guard let characteristicData = characteristic.value else { return -1 }
        
       
        
        let byteArray = [UInt8](characteristicData)
        let firstBitValue  = byteArray[0] & 0x01 // Bit1 [2] == 0010 & 0000 == 0000 == 0 (Dec) Wheel Rev FALSE (For Spd)
        let secondBitValue = byteArray[0] & 0x02 // Bit2 [2] == 0010 & 0010 == 0010 == 2 (Dec) Crank Rev TRUE  (For Cad)

        if firstBitValue > 0 {
            // Since using Wahoo RPM cadence only sensor. (Revisit Later)
        }

        if secondBitValue > 0 {
            let cumCrankRev   = Int(byteArray[2])<<8 + Int(byteArray[1])
            let lastCrankTime = Int(byteArray[4])<<8 + Int(byteArray[3])

            var deltaRotations = cumCrankRev - prevCumCrankRev
            if deltaRotations < 0 { deltaRotations += 65535 }

            var timeDelta = lastCrankTime - prevCrankTime
            if (timeDelta < 0) { timeDelta += 65535 }
            // In Case Cad Drops, we use PrevRPM
            // to substitute (up to 2 seconds before reporting 0)
            if (timeDelta != 0) {
                prevCrankStaleness = 0
                let timeMins =  Double(timeDelta) / 1024.0 / 60
                rpm = Double(deltaRotations) / timeMins
                prevRPM = rpm
            } else if (timeDelta == 0 && prevCrankStaleness < 2 ) {
                rpm = prevRPM
                prevCrankStaleness += 1
            } else if (prevCrankStaleness >= 2) {
                rpm = 0.0
            }

            prevCumCrankRev = cumCrankRev
            prevCrankTime = lastCrankTime
            if rpm != 0 {
                uiRpm = rpm
                NotificationCenter.default.post(name: .cadenceDataUpdated, object: rpm)
                //print(uiRpm)
            }
            return Int(uiRpm)
        }
        return -1
    }
}
