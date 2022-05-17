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
    @State var opacity = 0.0
    var body: some View {
        ZStack {
            SpriteView(scene: sceneManager.superBallScene)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ModalView()
                    Spacer()
                }
                Spacer()
            }
            .background(Color.black.opacity(0.5))
            .opacity(opacity)
            
            VStack {
                Spacer()
                Slider(value: $sceneManager.rotationX)
                Slider(value: $sceneManager.rotationY)
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 2)
            .padding(.bottom, 60)
        }
        .onChange(of: sceneManager.deviceConnected) { isConnected in
            if isConnected {
                opacity = 0
            } else {
                opacity = 1
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            
    }
}
