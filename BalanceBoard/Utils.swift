//
//  Utils.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SpriteKit


func *(left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width * right, height: left.height * right)
}

extension Collection where Element == CGFloat, Index == Int {
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }

        let sum: CGFloat = reduce(CGFloat(0)) { first, second -> CGFloat in
            return first + second
        }

        return sum / CGFloat(count)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x-point.x, 2) + pow(y-point.y, 2))
    }
}
