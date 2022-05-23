//
//  GameView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SwiftUI
import SpriteKit
import NavigationStack

struct GameView: View {
    @EnvironmentObject var nav: NavigationStack
    
    @StateObject var manager = GameManager()
    @State private var rotation = 0.0
    @State private var progress = 1.0
    
    func resetLoader() {        
        progress = 1.0
        rotation = 0.0
    }
    
    func startLoader() {
        withAnimation(.linear(duration: 3)) {
            progress = 0.0
            rotation = -4 * .pi
        }
    }
    
    func endGame() {
        nav.push(EndGameView().environmentObject(manager))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack() {
                SpriteView(scene: manager.scene, options: [.allowsTransparency])
                    .background(Image("background"))
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(manager.opacity)
                VStack {
                    HStack(alignment: .center, spacing: 24) {
                        ScoreboardView(
                            title: "TIME",
                            value: manager.timerString,
                            screenWidth: width
                        )
                        .opacity(manager.opacity)
                        ScoreboardView(
                            title: "FIREWALLS",
                            value: "\(manager.points)".leftPadding(toLength: 3, withPad: "0"),
                            screenWidth: width
                        )
                        .opacity(manager.opacity)
                        Spacer()
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: width / 10, height: width / 10, alignment: .center)
                            .overlay {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: width / 50, height: width / 50, alignment: .center)
                            }
                    }
                    Spacer()
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 32)
                if manager.status == .notStarted {
                    VStack {
                        Text("MOVE TO\nESCAPE!")
                            .font(.system(size: width / 17.5, weight: .heavy))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.init("Amarelo"))
                        Text("\(manager.loadValue)")
                            .font(.system(size: width / 7, weight: .heavy))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.init("Amarelo"))
                    }
                    .padding(.all, width / 7.5)
                    .background(
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: width / 25, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.init("Azul"))
                            .rotationEffect(Angle(radians: rotation))
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            manager.view = self
            manager.startLoader()
            BLEManager.instance.delegates["gameManager"] = manager
        }
        .environmentObject(manager)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameView()
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
