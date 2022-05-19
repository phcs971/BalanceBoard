//
//  GameScene.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SpriteKit

class GameScene: SKScene {
    
    private var side: CGFloat = 0.0
    
    let colorTween = SKAction.sequence([
        SKAction.colorTransitionAction(
            fromColor: .init(named: "Roxo")!,
            toColor: .init(named: "Rosa")!,
            duration: 1.5
        ),
        SKAction.colorTransitionAction(
            fromColor: .init(named: "Rosa")!,
            toColor: .init(named: "Laranja")!,
            duration: 1.5
        ),
        SKAction.colorTransitionAction(
            fromColor: .init(named: "Laranja")!,
            toColor: .init(named: "Amarelo")!,
            duration: 1.5
        ),
        SKAction.colorTransitionAction(
            fromColor: .init(named: "Amarelo")!,
            toColor: .init(named: "Verde")!,
            duration: 1.5
        ),
    ])
    
    //    private var wallModelNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        scene!.size = view.layer.frame.size
        side = sqrt(scene!.size.width * scene!.size.width + scene!.size.height * scene!.size.height)
        
        scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addWall()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.addWall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.addWall()
            }
        }
    }
    func addBall(position: CGPoint = .zero) {
        let node = SKSpriteNode()
        node.position = position
        let ball = SKShapeNode(circleOfRadius: 0.025 * side)
        ball.fillColor = .init(named: "Azul")!
        ball.strokeColor = .clear
        
        let body = SKPhysicsBody(circleOfRadius: 0.025 * side)
        body.affectedByGravity = false
        
        node.physicsBody = body
        addChild(node)
        node.addChild(ball)
    }
    
    var i = 0
    
    func addWall() {
        let possibleArcs: [[[CGFloat]]] = [
            [ [0, 60] ],
            [ [0, 45] ],
            [ [0, 45], [180, 225] ],
            [ [0, 180] ],
            [ [0, 60], [180, 240] ],
            [ [0, 45], [90, 135], [180, 225], [270, 315] ]
        ]
        let colors: [UIColor] = [
            .init(named: "Roxo")!,
            .init(named: "Rosa")!,
            .init(named: "Laranja")!,
            .init(named: "Amarelo")!,
            .init(named: "Verde")!,
        ]
        let w = WallModel(
            rotationAngle: Double.random(in: 0..<360),
            arcAngles: possibleArcs.randomElement()!,
            color: colors[i]
        )
        i += 1
        if (i == colors.count) { i = 0 }
        let node = SKSpriteNode()
        node.position = .zero
        let widthProp = w.externalRadius / w.internalRadius
        node.size = w.size * (side * widthProp)
        node.zRotation = w.rotationAngle * .pi / 180
        
        for (index, arc) in w.arcAngles.enumerated() {
            let nextArc = w.arcAngles.count == 1 ? arc : index == w.arcAngles.count - 1 ? w.arcAngles[0] : w.arcAngles[index + 1]
            let start = arc[1] * .pi / 180
            let end = nextArc[0] * .pi / 180
            let p = UIBezierPath()
            
            
            p.addArc(withCenter: .zero, radius: w.externalRadius * side * widthProp, startAngle: start, endAngle: end, clockwise: true)
            let round1 = CGPoint(
                x: cos(end) * w.radius * side * widthProp,
                y: sin(end) * w.radius * side * widthProp
            )
            p.addArc(
                withCenter: round1,
                radius: (w.externalRadius - w.radius) * side * widthProp,
                startAngle: end,
                endAngle: .pi + end,
                clockwise: true
            )
            
            p.addArc(withCenter: .zero, radius: w.internalRadius * side * widthProp, startAngle: end, endAngle: start, clockwise: false)
            
            let round2 = CGPoint(
                x: cos(start) * w.radius * side * widthProp,
                y: sin(start) * w.radius * side * widthProp
            )
            p.addArc(
                withCenter: round2,
                radius: (w.externalRadius - w.radius) * side * widthProp,
                startAngle: .pi + start,
                endAngle: start,
                clockwise: true
            )
            p.close()
            
            let shape = SKShapeNode(path: p.cgPath)
            shape.fillColor = w.color
            shape.strokeColor = .clear
            let body = SKPhysicsBody(polygonFrom: p.cgPath)
            body.affectedByGravity = false
            body.isDynamic = false
            body.categoryBitMask = 0b001
            body.contactTestBitMask = 0b010
            body.collisionBitMask = 0b010
            shape.physicsBody = body
            node.addChild(shape)
            
//            shape.run(colorTween)
        }
        
        addChild(node)
        
        
        node.run(
            SKAction.group([
                SKAction.scale(by: 0.01, duration: 6),
                SKAction.rotate(byAngle: 4 * .pi, duration: 6),
            ])
        ) {
            node.removeFromParent()
            DispatchQueue.main.async { self.addWall() }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            addBall(position: t.location(in: self))
        }
    }
}

struct WallModel {
    var size: CGSize { get { .init(width: externalRadius * 2, height: externalRadius * 2) } }
    var externalRadius: CGFloat = 0.5
    var radius: CGFloat { get { (externalRadius + internalRadius) / 2  } }
    var internalRadius: CGFloat { get { externalRadius - 0.05 } }
    
    var rotationAngle: CGFloat
    var arcAngles: [[CGFloat]]
    var color: UIColor
}

func lerp(a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat { (b-a) * fraction + a }

struct ColorComponents {
    var red = CGFloat(0)
    var green = CGFloat(0)
    var blue = CGFloat(0)
    var alpha = CGFloat(0)
}

extension UIColor {
    func toComponents() -> ColorComponents {
        var components = ColorComponents()
        getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
        return components
    }
}

extension SKAction {
    static func colorTransitionAction(fromColor : UIColor, toColor : UIColor, duration : Double = 0.4) -> SKAction {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let startColorComponents = fromColor.toComponents()
            let endColorComponents = toColor.toComponents()
            let transColor = UIColor(
                red: lerp(a: startColorComponents.red, b: endColorComponents.red, fraction: fraction),
                green: lerp(a: startColorComponents.green, b: endColorComponents.green, fraction: fraction),
                blue: lerp(a: startColorComponents.blue, b: endColorComponents.blue, fraction: fraction),
                alpha: lerp(a: startColorComponents.alpha, b: endColorComponents.alpha, fraction: fraction))
            (node as? SKShapeNode)?.fillColor = transColor
        })
    }
}
