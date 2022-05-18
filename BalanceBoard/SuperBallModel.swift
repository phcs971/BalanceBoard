//
//  SuperBallModel.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SpriteKit
import SwiftUI

class SuperBallModel {
    private var node: SKSpriteNode
    private var circleNode: SKShapeNode
    private var parent: SKScene
    
    init(parent: SKScene) {
        self.parent = parent
        node = SKSpriteNode()
        node.name = "superBall"
        node.position = CGPoint(x: -730, y: 0)
        circleNode = SKShapeNode(circleOfRadius: 20)
        circleNode.fillColor = .green
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.contactTestBitMask = node.physicsBody!.collisionBitMask
        
        node.addChild(circleNode)
        parent.addChild(node)
    }
    
    func reset() {
        node.removeFromParent()
        node.position = CGPoint(x: -730, y: 0)
        parent.addChild(node)
    }
    
    func updateVelocity(velocity: CGVector) {
        node.physicsBody?.velocity.dx = velocity.dx
        node.physicsBody?.velocity.dy = velocity.dy
    }
}
