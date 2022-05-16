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
    
    init(parent: SKScene) {
        node = SKSpriteNode()
        circleNode = SKShapeNode(circleOfRadius: 20)
        circleNode.fillColor = .green
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        node.physicsBody?.affectedByGravity = true
        
        node.addChild(circleNode)
        parent.addChild(node)
    }
    
    func accelerate() {
        
    }
}
