//
//  SuperBallScene.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SpriteKit

class SuperballScene: SKScene, SKPhysicsContactDelegate {
    var movingBall: SuperBallModel?
    private var targetBall: SKSpriteNode?
    
    private var boundary = SKSpriteNode()
    private let wall = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 700))
    private var walls: [SKSpriteNode] = []
    
    weak var sceneManager: SceneManager?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        movingBall = SuperBallModel(parent: self)
        
        targetBall = SKSpriteNode()
        let colorBall = SKShapeNode(circleOfRadius: 20)
        colorBall.fillColor = .blue
        targetBall?.addChild(colorBall)
        targetBall?.position = CGPoint(x: 750, y: 0)
        targetBall?.name = "target"
        targetBall?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        targetBall?.physicsBody?.affectedByGravity = false
        targetBall?.physicsBody?.isDynamic = false
        targetBall?.physicsBody?.contactTestBitMask = targetBall!.physicsBody!.collisionBitMask
        
        // Boundary setup
        let top = SKSpriteNode(color: .gray, size: CGSize(width: 1800, height: 50))
        top.position = CGPoint(x: 0, y: 550)
        top.name = "topBoundary"
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1800, height: 50))
        let bottom = SKSpriteNode(color: .gray, size: CGSize(width: 1800, height: 50))
        bottom.position = CGPoint(x: 0, y: -550)
        bottom.name = "bottomBoundary"
        bottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1800, height: 50))
        let left = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 1800))
        left.position = CGPoint(x: -850, y: 0)
        left.name = "leftBoundary"
        left.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 1800))
        let right = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 1800))
        right.position = CGPoint(x: 850, y: 0)
        right.name = "rightBoundary"
        right.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 1800))
        
        boundary.addChild(top)
        boundary.addChild(bottom)
        boundary.addChild(left)
        boundary.addChild(right)
        
        for node in boundary.children {
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.contactTestBitMask = node.physicsBody!.collisionBitMask
        }
        
        // Wall spawner setup
        wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 700))
        wall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        wall.physicsBody?.contactTestBitMask = wall.physicsBody!.collisionBitMask
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.isDynamic = false
        
        let sortDivision = Int.random(in: 2...4)
        spawn(divisions: sortDivision)
        
        self.addChild(targetBall!)
        self.addChild(boundary)
    }
    
    func spawn(divisions: Int) {
        for i in 0...divisions {
            let xCoordinate = -650+CGFloat(i)*1300/CGFloat(divisions)
            let yCoordinate = CGFloat.random(in: -300...300)
            let topWall = wall.copy() as! SKSpriteNode
            let bottomWall = wall.copy() as! SKSpriteNode
            
            topWall.position = CGPoint(x: xCoordinate, y: yCoordinate + 450)
            bottomWall.position = CGPoint(x: xCoordinate, y: yCoordinate - 450)
            self.addChild(topWall)
            self.addChild(bottomWall)
            walls.append(topWall)
            walls.append(bottomWall)
        }
    }
    
    func reset() {
        for wallNode in walls {
            wallNode.removeFromParent()
        }
        let sortDivision = Int.random(in: 2...4)
        spawn(divisions: sortDivision)
        movingBall?.reset()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.node?.name == "bottomBoundary" || contact.bodyB.node?.name == "bottomBoundary" {
//            movingBall?.bounceVertical()
//        }
//        movingBall?.bounceVertical()
////        movingBall?.reset()
//        print("Contact")
        if contact.bodyA.node?.name == targetBall?.name || contact.bodyB.node?.name == targetBall?.name {
            reset()
//            print("Target")
        }
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        if movingBall!.containsNode(targetNode: targetBall!) {
//            sceneManager?.resetScene()
//        }
//    }
}
