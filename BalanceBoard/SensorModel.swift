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
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
}

func -(left: VectorModel, right: VectorModel) -> VectorModel {
    VectorModel(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

func +(left: VectorModel, right: VectorModel) -> VectorModel {
    VectorModel(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func *(left: VectorModel, right: Double) -> VectorModel {
    VectorModel(x: left.x * right, y: left.y * right, z: left.z * right)
}

func /(left: VectorModel, right: Double) -> VectorModel {
    VectorModel(x: left.x / right, y: left.y / right, z: left.z / right)
}

extension Collection where Element == VectorModel, Index == Int {
    var average: VectorModel? {
        guard !isEmpty else { return nil }

        let sum: VectorModel = reduce(VectorModel()) { first, second -> VectorModel in
            return first + second
        }

        return sum / Double(count)
    }
}

extension Collection where Element == SensorModel, Index == Int {
    var average: SensorModel? {
        guard !isEmpty else { return nil }
        
        let temp: Double = reduce(0) { first, second -> Double in
            return first + second.temp
        }
        
        return SensorModel(
            temp: temp,
            angle: map { $0.angle }.average ?? VectorModel(),
            gyro: map { $0.gyro }.average ?? VectorModel(),
            acc: map { $0.acc }.average ?? VectorModel()
        )
    }
}


