//
//  GameView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var body: some View {
        SpriteView(scene: GameScene(), options: [.allowsTransparency])
            .edgesIgnoringSafeArea(.all)
            .background(Image("textura-fundo").scaledToFill())
            .background(Color.black)
            
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
