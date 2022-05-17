//
//  BLEManager.swift
//  ExampleBLEBalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 16/05/22.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BLEManager: NSObject, ObservableObject {
    var serviceUUID: CBUUID = .init(string: "DA1A")
    var characteristicUUID: CBUUID = .init(string: "A001")
    
    var centralManager: CBCentralManager!
    
    var boardPeripheral: CBPeripheral?
    
    var sensorCharacteristic: CBCharacteristic?
    
    var notifying = false
    
    static let instance = BLEManager()
    
    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID])
    }
}

extension BLEManager: CBCentralManagerDelegate {
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
            startScanning()
        @unknown default:
            print("central.state is .unknown default")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        boardPeripheral = peripheral
        
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CONNECTED")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("FAILED TO CONNECT")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("DISCONNECTED")
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                sensorCharacteristic = characteristic
                setNotify()
            }
        }
    }
    
    func setNotify(_ value: Bool = true) {
        if let c = sensorCharacteristic, let p = boardPeripheral {
            p.setNotifyValue(value, for: c)
            notifying = value
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == characteristicUUID {
            if let value = characteristic.value {
                let _ = try? JSONDecoder().decode(SensorModel.self, from: value)
            }
        }
    }
}


