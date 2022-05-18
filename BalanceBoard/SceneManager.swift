//
//  SceneManager.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SwiftUI

class SceneManager: NSObject, ObservableObject {
    //    @Published var deviceConnected = false
    //    @Published var rotationX = 0.5 {
    //        didSet {
    //            setSceneGravity()
    //        }
    //    }
    //    @Published var rotationY = 0.5 {
    //        didSet {
    //            setSceneGravity()
    //        }
    //    }
    
    var lastValues = [SensorModel]()
    @Published var currentValue: SensorModel?
    
    @Published var superBallScene: SuperballScene
    
    var stationaryStateAcc = VectorModel(x: -0.067, y: 0.121, z: 1.017)
    
    override init() {
        superBallScene = SuperballScene()
        super.init()
        superBallScene.size = CGSize(width: 1800, height: 1200)
        superBallScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        superBallScene.scaleMode = .aspectFit
        superBallScene.sceneManager = self
    }
    
    
    
    //    func setSceneGravity() {
    //        superBallScene.physicsWorld.gravity = CGVector(dx: 9.81 * 2 * (rotationX - 0.5), dy: 9.81 * 2 * (rotationY - 0.5))
    //    }
    //
    //    func resetScene() {
    //        print("Reset")
    //        let scene = SuperballScene()
    //        superBallScene = scene
    //        superBallScene.sceneManager = self
    //        superBallScene.size = CGSize(width: 1800, height: 1200)
    //        superBallScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    //        superBallScene.scaleMode = .aspectFit
    //    }
    let multi = 10.0
    let min = 0.1
}

extension SceneManager: BLEManagerDelegate {
    func onUpdate(_ value: SensorModel) {
        lastValues.append(value)
        lastValues = lastValues.suffix(20)
        currentValue = lastValues.average
        print(currentValue?.acc.x ?? "SEM X", currentValue?.acc.y ?? "SEM Y", currentValue?.acc.z ?? "SEM Z")
        let va = currentValue!.acc - stationaryStateAcc
        print(va.x, va.y, va.z)
        currentValue = value
        if let v = currentValue?.acc {
            let gravity = (v - stationaryStateAcc)
            
            print(gravity.x, gravity.y, gravity.z)
            print("")
            //            print("")
//            superBallScene.movingBall?.updateVelocity(velocity: CGVector(
//                dx: -v.x * multi * 100,
//                dy: -v.y * multi * 100
//            ))
            superBallScene.physicsWorld.gravity = CGVector(
                dx: abs(gravity.x) > min ? -gravity.x * multi : 0,
                dy: abs(gravity.y) > min ? -gravity.y * multi : 0
            )
        }
    }
}
