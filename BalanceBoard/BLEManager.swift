//
//  BLEManager.swift
//  ExampleBLEBalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 16/05/22.
//

import Foundation
import CoreBluetooth
import SwiftUI

enum ConnectionState {
    case waiting
    case scanning
    case connected
    case failed
}

class BLEManager: NSObject, ObservableObject {
    var serviceUUID: CBUUID = .init(string: "DA1A")
    var characteristicUUID: CBUUID = .init(string: "A001")
    
    var delegates = [String: BLEManagerDelegate]()
    
    var centralManager: CBCentralManager!
    
    var boardPeripheral: CBPeripheral?
    
    var sensorCharacteristic: CBCharacteristic?
    
    @Published var notifying = false
    @Published var connected = false
    
    //Connection View
    @Published var connectionState: ConnectionState = .waiting
    
    static let instance = BLEManager()
    
    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
//        connectionState = .scanning
    }
    
    
    func startScanning() {
        print("Start scanning")
        connectionState = .scanning
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
        if peripherals.isEmpty {
            centralManager.scanForPeripherals(withServices: [serviceUUID])
        } else {
            boardPeripheral = peripherals.first!
            if boardPeripheral!.state == .connected {
                boardPeripheral!.delegate = self
                boardPeripheral!.discoverServices([serviceUUID])
            } else {
                centralManager.connect(boardPeripheral!)
            }
        }
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
        print("Discovered peripheral")
        boardPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CONNECTED")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        connected = true
        connectionState = .connected
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("FAILED TO CONNECT")
        connected = false
        connectionState = .failed
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("DISCONNECTED")
        connected = false
        connectionState = .failed
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        print("Service found")
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("Characteristics found")
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
                if let v = try? JSONDecoder().decode(SensorModel.self, from: value) {
                    print("decoded")
                    print(delegates)
                    for d in delegates.values {
                        d.onUpdate(v)
                        print("updated")
                    }
                }
            }
        }
    }
}

protocol BLEManagerDelegate: NSObject {
    func onUpdate(_ value: SensorModel)
}


