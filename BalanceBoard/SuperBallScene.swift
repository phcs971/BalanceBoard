//
//  SuperBallScene.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SpriteKit

class SuperballScene: SKScene {
    private var movingBall: SuperBallModel?
    private var targetBall: SKShapeNode?
    
    override func didMove(to view: SKView) {
        movingBall = SuperBallModel(parent: self)
        
        targetBall = SKShapeNode(circleOfRadius: 20)
        targetBall!.fillColor = .blue
        self.addChild(targetBall!)
    }
}
