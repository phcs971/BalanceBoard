//
//  SceneManager.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 16/05/22.
//

import SwiftUI

class SceneManager: ObservableObject {
    var superBallScene: SuperballScene
    
    init() {
        superBallScene = SuperballScene()
        superBallScene.size = CGSize(width: 1800, height: 1200)
        superBallScene.scaleMode = .aspectFit
    }
}
