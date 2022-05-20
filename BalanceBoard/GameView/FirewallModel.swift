//
//  WallModel.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 20/05/22.
//

import SpriteKit


struct FirewallModel {
    var size: CGSize { get { .init(width: externalRadius * 2, height: externalRadius * 2) } }
    var externalRadius: CGFloat = 0.5
    var radius: CGFloat { get { (externalRadius + internalRadius) / 2  } }
    var internalRadius: CGFloat { get { externalRadius - 0.05 } }
    
    var rotationAngle: CGFloat
    var arcAngles: [[CGFloat]]
    var color: UIColor
    
    static func random() -> FirewallModel {
        colorIndex += 1
        if colorIndex == colors.count { colorIndex = 0 }
        return FirewallModel(
            rotationAngle: Double.random(in: 0..<360),
            arcAngles: possibleArcs.randomElement()!,
            color: colors[colorIndex]
        )
    }
    
    private static var colorIndex = 0
    private static let possibleArcs: [[[CGFloat]]] = [
        [ [0, 60] ],
        [ [0, 180] ],
        [ [0, 60], [120, 180] ],
        [ [0, 45], [180, 225] ],
        [ [0, 60], [180, 240] ],
        [ [0, 90], [180, 270] ],
        [ [0, 60], [120, 180], [240, 300] ],
        [ [0, 45], [90, 135], [180, 225], [270, 315] ]
    ]
    private static let colors: [UIColor] = [
        .init(named: "Roxo")!,
        .init(named: "Rosa")!,
        .init(named: "Laranja")!,
        .init(named: "Amarelo")!,
        .init(named: "Verde")!,
    ]
}
