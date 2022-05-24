//
//  CalibrationManager.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 23/05/22.
//

import SwiftUI

enum CalibrationState {
    case waiting
    case starting
    case center
    case left
    case right
    case down
    case up
    case finished
}

class CalibrationManager: NSObject, ObservableObject {
    @Published var calibrationState: CalibrationState = .waiting
    @Published var currentInclination = CGVector(dx: 0, dy: 0)
    @Published var currentValue: SensorModel?
//    var stationaryStateAcc = VectorModel(x: -0.067, y: 0.121, z: 1.017)
    var stationaryStateAcc = VectorModel(x: 0, y: 0, z: 0)
    var lastValues = [SensorModel]()
    private var maximumAngleX: CGFloat = 0.1
    private var maximumAngleY: CGFloat = 0.1
    
}


extension CalibrationManager: BLEManagerDelegate {
    func onUpdate(_ value: SensorModel) {
        // Inclination update
        if abs(value.acc.x) > maximumAngleX {
            maximumAngleX = abs(value.acc.x)
        }
        if abs(value.acc.y) > maximumAngleY {
            maximumAngleY = abs(value.acc.y)
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            let dxUnit = value.acc.x // pow(pow(value.acc.x, 2) + pow(value.acc.y, 2), 0.5)
            let dyUnit = value.acc.y // pow(pow(value.acc.x, 2) + pow(value.acc.y, 2), 0.5)
            currentInclination = CGVector(dx: -dxUnit/maximumAngleX, dy: dyUnit/maximumAngleY)
        }
    }
}
