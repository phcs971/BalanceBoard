//
//  GameView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 18/05/22.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var manager = GameManager()
    var body: some View {
        ZStack() {
            SpriteView(scene: manager.scene, options: [.allowsTransparency])
                .background(Image("background"))
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack(alignment: .center, spacing: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("TIME")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Text(manager.timerString)
                            .font(.system(size: 40, weight: .light, design: .default))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 4)
                    .frame(minWidth: 212)
                    .background(RoundedRectangle(cornerRadius: 80).stroke(Color.white, lineWidth: 1))
                    .background(Color.black)
                    .cornerRadius(80)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("FIREWALLS")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Text("\(manager.points)".leftPadding(toLength: 3, withPad: "0"))
                            .font(.system(size: 40, weight: .light, design: .default))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 80).stroke(Color.white, lineWidth: 1))
                    .background(Color.black)
                    .cornerRadius(80)
                    Spacer()
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 112, height: 112, alignment: .center)
                        .overlay {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                }
                Spacer()
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 32)
        }
        .preferredColorScheme(.dark)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
