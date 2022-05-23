//
//  GameScene.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SpriteKit

class GameScene: SKScene {
    var manager: GameManager!
    
    private var screenDiagonal: CGFloat = 0.0
    
    private var ballNode: SKSpriteNode!
    
    private var interval = 2.0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        scene!.size = view.layer.frame.size
        scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        screenDiagonal = sqrt(scene!.size.width * scene!.size.width + scene!.size.height * scene!.size.height)
        
        addBall(position: CGPoint(x: 200, y: 200))
        
        isPaused = true
        self.view?.isPaused = true
    }
    
    func addBall(position: CGPoint = .zero) {
        let radius = 0.025 * screenDiagonal
        let size = CGSize(width: 2 * radius, height: 2 * radius)
        ballNode = SKSpriteNode(imageNamed: "GameRobot")
        ballNode.zPosition = 1
        ballNode.position = position
        ballNode.size = size
        
        let body = SKPhysicsBody(texture: SKTexture(imageNamed: "GameRobotAlpha"), alphaThreshold: 0.5, size: size)
        body.affectedByGravity = false
        body.allowsRotation = false
        body.angularDamping = .infinity
        body.angularVelocity = 0
        
        ballNode.physicsBody = body
        addChild(ballNode)
//        ballNode.addChild(ball)
    }
    
    func addWall() {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.interval /= 1.01
            if self.manager.status == .started { self.addWall() }
        }
        let w = FirewallModel.random()
        
        let sizeProportion = self.screenDiagonal * w.externalRadius / w.internalRadius
        let node = SKSpriteNode()
        node.zPosition = 0
        node.position = .zero
        node.size = w.size * sizeProportion
        node.zRotation = w.rotationAngle * .pi / 180
        
        for (index, arc) in w.arcAngles.enumerated() {
            let nextArc = w.arcAngles.count == 1 ? arc : index == w.arcAngles.count - 1 ? w.arcAngles[0] : w.arcAngles[index + 1]
            let start = arc[1] * .pi / 180
            let end = nextArc[0] * .pi / 180
            
            let midEnd = CGPoint(
                x: cos(end) * w.radius * sizeProportion,
                y: sin(end) * w.radius * sizeProportion
            )
            let midStart = CGPoint(
                x: cos(start) * w.radius * sizeProportion,
                y: sin(start) * w.radius * sizeProportion
            )
            
            let path = UIBezierPath()
            
            path.addArc(
                withCenter: .zero,
                radius: w.externalRadius * sizeProportion,
                startAngle: start,
                endAngle: end,
                clockwise: true
            )
            
            path.addArc(
                withCenter: midEnd,
                radius: (w.externalRadius - w.radius) * sizeProportion,
                startAngle: end,
                endAngle: .pi + end,
                clockwise: true
            )
            
            path.addArc(
                withCenter: .zero,
                radius: w.internalRadius * sizeProportion,
                startAngle: end,
                endAngle: start,
                clockwise: false
            )
            
            path.addArc(
                withCenter: midStart,
                radius: (w.externalRadius - w.radius) * sizeProportion,
                startAngle: .pi + start,
                endAngle: start,
                clockwise: true
            )
            
            path.close()
            
            let shape = SKShapeNode(path: path.cgPath)
            shape.fillColor = w.color
            shape.strokeColor = .clear
            
            let body = SKPhysicsBody(polygonFrom: path.cgPath)
            body.affectedByGravity = false
            body.isDynamic = false
            shape.physicsBody = body
            node.addChild(shape)
        }
        
        addChild(node)
        
        let innerRadius = node.size.width * w.internalRadius / w.externalRadius
        let scale = ballNode.size.width / innerRadius
        let actions = SKAction.group([
            SKAction.scale(by: scale, duration: 6),
            SKAction.rotate(byAngle: 4 * .pi, duration: 6),
        ])
        node.run(actions) {
            self.checkBall()
            node.removeFromParent()
        }
    }
    
    func checkBall() {
        DispatchQueue.main.async {
            if self.ballNode.position.distance() > 10 {
                self.manager.addPoint()
            } else {
                self.manager.endGame()
            }
        }
    }
}


