//
//  EndGameView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 23/05/22.
//

import SwiftUI
import NavigationStack

struct EndGameView: View {
    @EnvironmentObject var nav: NavigationStack
    @EnvironmentObject var manager: GameManager
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Image("Confetti")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Spacer()
                    Group {
                        Text(manager.timerString)
                            .font(.system(size: width / 40, weight: .light))
                            .foregroundColor(.black)
                        Text("\(manager.points)")
                            .font(.system(size: width / 40, weight: .light))
                            .foregroundColor(.black)
                        Image("Congrats")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width / 3.7)
                        Spacer().frame(height: height / 50)
                        Text("Best")
                            .font(.system(size: width / 60, weight: .bold))
                            .foregroundColor(.black)
                        Text(GameService.instace.time)
                            .font(.system(size: width / 58, weight: .light))
                            .foregroundColor(.black)
                        Text("\(GameService.instace.highScore)")
                            .font(.system(size: width / 58, weight: .light))
                            .foregroundColor(.black)
                    }
                    Spacer().frame(height: height / 20)
                    HStack(alignment: .center, spacing: height / 50) {
                        Button {
                            nav.pop(to: .root)
                            nav.push(GameView())
                        } label: {
                            HStack(alignment: .center, spacing: width / 85) {
                                Image("arrow")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: width / 25)
                                Text("RETRY")
                                    .font(.system(size: width / 40, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: width/5, height: width/20)
                        .background(
                            RoundedRectangle(cornerRadius: width / 40)
                                .stroke(.black, lineWidth: 4))
                        .background(Color("Branco"))
                        .cornerRadius(.infinity)
                        Button {
                            nav.pop(to: .root)
                            nav.push(MenuView())
                        } label: {
                            HStack(alignment: .center, spacing: width / 85) {
                                Text("BACK")
                                    .font(.system(size: width / 40, weight: .medium))
                                    .foregroundColor(.black)
                                Image("arrow")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: width / 25)
                                    .rotationEffect(.init(degrees: 180))
                            }
                        }
                        .frame(width: width/5, height: width/20)
                        .background(
                            RoundedRectangle(cornerRadius: width / 40)
                                .stroke(.black, lineWidth: 4))
                        .background(Color("Branco"))
                        .cornerRadius(.infinity)
                    }
                    Spacer().frame(height: height / 50 + width / 20)
                    Spacer()
                }
            }
        }
        .background(Color("Branco"))
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
