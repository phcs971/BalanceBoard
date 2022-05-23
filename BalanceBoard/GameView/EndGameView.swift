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
                    Text("00:00")
                        .font(.system(size: width / 40, weight: .light))
                    Image("Congrats")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width / 3.7)
                    Spacer().frame(height: height / 50)
                    
                    Text("Best")
                        .font(.system(size: width / 60, weight: .bold))
                    Text("00:00")
                        .font(.system(size: width / 58, weight: .light))
                    Spacer().frame(height: height / 20)
//                    HStack() {
//                        
//                    }
                    Spacer().frame(height: height / 50)
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
