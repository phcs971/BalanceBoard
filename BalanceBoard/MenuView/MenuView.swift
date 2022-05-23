//
//  MenuView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 23/05/22.
//

import SwiftUI
import NavigationStack


struct MenuView: View {
    let circles = 6
    
    @State private var opacity = 1.0
    @State private var scale = 1.0
    @State private var bottom = 32.0
    
    @State private var game = false
    
    @EnvironmentObject private var nav: NavigationStack
    
    func start() {
        let duration = 0.4
        withAnimation(.easeInOut(duration: duration)) { self.opacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            let duration = 0.8
            withAnimation(.easeInOut(duration: duration)) {
                self.scale = 10.0
                self.bottom = 8
            }
            self.nav.push(GameView())
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                ForEach(1..<11) { index in
                    let diag = sqrt(pow(geometry.size.width, 2) + pow(geometry.size.height, 2))
                    let size = diag * CGFloat(10 - index + 1) / CGFloat(10)
                    CircleView(index: index, diameter: size)
                }
                ZStack {
                    VStack {
                        Spacer().frame(height: geometry.size.height / 10)
                        Image("GER")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 2)
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        Image("Robot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 6 / 14)
                        Spacer().frame(height: geometry.size.height / bottom)
                    }
                    .scaleEffect(scale)
                    
                    VStack {
                        Spacer()
                        Button {
                            start()
                        } label: {
                            Text("PLAY")
                                .font(.system(size: 80, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 120)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 80)
                                .stroke(.black, lineWidth: 4))
                        .background(Color("Branco"))
                        .cornerRadius(100)
                        Spacer().frame(height: geometry.size.height / 12)
                    }
                    .opacity(opacity)
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .background(Color("Azul"))
        .onAppear {
            opacity = 1.0
            scale = 1.0
            bottom = 32.0
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView(transitionType: .custom(.opacity), easing: .easeInOut(duration: 1)) {
            MenuView()
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
