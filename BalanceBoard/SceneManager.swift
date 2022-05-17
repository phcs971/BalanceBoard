//
//  SceneManager.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SwiftUI

class SceneManager: ObservableObject {
    @Published var deviceConnected = false
    @Published var rotationX = 0.5 {
        didSet {
            setSceneGravity()
        }
    }
    @Published var rotationY = 0.5 {
        didSet {
            setSceneGravity()
        }
    }
    
    @Published var superBallScene: SuperballScene
    
    init() {
        superBallScene = SuperballScene()
        superBallScene.sceneManager = self
        superBallScene.size = CGSize(width: 1800, height: 1200)
        superBallScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        superBallScene.scaleMode = .aspectFit
    }
    
    func setSceneGravity() {
        superBallScene.physicsWorld.gravity = CGVector(dx: 9.81 * 2 * (rotationX - 0.5), dy: 9.81 * 2 * (rotationY - 0.5))
    }
    
//    func resetScene() {
//        print("Reset")
//        let scene = SuperballScene()
//        superBallScene = scene
//        superBallScene.sceneManager = self
//        superBallScene.size = CGSize(width: 1800, height: 1200)
//        superBallScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        superBallScene.scaleMode = .aspectFit
//    }
}
