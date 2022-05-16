//
//  SensorModel.swift
//  ExampleBLEBalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 16/05/22.
//

import Foundation

struct SensorModel: Codable {
    var temp: Double
    var angle: VectorModel
    var gyro: VectorModel
    var acc: VectorModel
}

struct VectorModel: Codable {
    var x: Double
    var y: Double
    var z: Double
}

func -(left: VectorModel, right: VectorModel) -> VectorModel {
    VectorModel(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}
