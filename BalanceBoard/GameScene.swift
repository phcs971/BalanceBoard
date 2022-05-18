//
//  GameScene.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SpriteKit

class GameScene: SKScene {
    
    private var side: CGFloat = 0.0
    
//    private var wallModelNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        scene!.size = view.layer.frame.size
        side = max(scene!.size.width, scene!.size.height)
        print(scene!.size)
        print(side)
        print(UIScreen.main.bounds.size)
        scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addWall()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.addWall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.addWall()
            }
        }
    }
    
    func addWall() {
        var w = WallModel(
            externalRadius: 0.5,
            rotationAngle: 0,
            arcAngles: [
                [0, 45],
                [180, 225]
            ]
        )
        let node = SKSpriteNode()
        node.position = .zero
        node.size = w.size * side * 1.25
        let path = UIBezierPath()
        
        for (index, arc) in w.arcAngles.enumerated() {
            let nextArc = w.arcAngles.count == 1 ? arc : index == w.arcAngles.count - 1 ? w.arcAngles[0] : w.arcAngles[index + 1]
            let start = arc[1] * .pi / 180
            let end = nextArc[0] * .pi / 180
            let p = UIBezierPath()
            
            p.addArc(withCenter: .zero, radius: w.internalRadius * side * 1.25, startAngle: start, endAngle: end, clockwise: true)
            p.addArc(withCenter: .zero, radius: w.externalRadius * side * 1.25, startAngle: end, endAngle: start, clockwise: false)
            p.close()
            
            path.append(p)
        }
        path.close()
        let shape = SKShapeNode(path: path.cgPath)
        shape.fillColor = .blue
        shape.strokeColor = .clear
        node.addChild(shape)
        addChild(node)
        w.node = node
        w.shape = shape
        
        node.run(
        SKAction.group([
            SKAction.scale(by: 0.01, duration: 6),
            SKAction.rotate(byAngle: 4 * .pi, duration: 6),
        ])
        ) {
            node.removeFromParent()
            DispatchQueue.main.async {
                self.addWall()
            }
        }
    }
}

struct WallModel {
    var size: CGSize { get { .init(width: externalRadius * 2, height: externalRadius * 2) } }
    var externalRadius: CGFloat
    var radius: CGFloat { get { [externalRadius, internalRadius].average! } }
    var internalRadius: CGFloat { get { externalRadius - 0.075 } }
    
    var rotationAngle: CGFloat {
        didSet { if let node = node { node.zRotation = rotationAngle * .pi / 180 } }
    }
    var arcAngles: [[CGFloat]]
    
    var node: SKSpriteNode?
    var shape: SKShapeNode?
}
