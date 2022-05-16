//
//  ContentView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 16/05/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var sceneManager: SceneManager = SceneManager()
    var body: some View {
        VStack {
            SpriteView(scene: sceneManager.superBallScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            .ignoresSafeArea()
    }
}
