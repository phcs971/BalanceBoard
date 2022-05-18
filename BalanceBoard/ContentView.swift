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
    @StateObject var bleManager: BLEManager = BLEManager.instance
    @State var opacity = 1.0
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
            
//            VStack {
//                Spacer()
//                Slider(value: $sceneManager.rotationX)
//                Slider(value: $sceneManager.rotationY)
//            }
//            .frame(maxWidth: UIScreen.main.bounds.width / 2)
//            .padding(.bottom, 60)
        }
        .onAppear {
            bleManager.delegates["sceneManager"] = sceneManager
        }
        .onDisappear {
            bleManager.delegates.removeValue(forKey: "sceneManager")
        }
        .onChange(of: bleManager.connected) { opacity = $0 ? 0 : 1 }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            
    }
}
