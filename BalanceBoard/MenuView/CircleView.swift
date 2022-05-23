//
//  CircleView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 23/05/22.
//

import SwiftUI

struct CircleView: View {
    let index: Int
    let diameter: CGFloat
    
    let colors: [String] = [
        "Laranja",
        "Laranja",
        "Amarelo",
        "Amarelo",
        "Azul",
        "Azul",
        "Roxo",
        "Roxo",
        "Rosa",
        "Rosa",
    ]
    @State private var color: Color = .white
    @State private var currentIndex = 0
    
    func changeColor() {
        currentIndex += 1
        let duration: TimeInterval = 0.5
        withAnimation(.linear(duration: duration)) {
            self.color = Color(colors.itemForIndex(currentIndex)!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.changeColor()
        }
    }
    
    var body: some View {
        Circle()
            .stroke(Color.black)
            .background(
                Circle()
                    .fill(Color.white)
                    .colorMultiply(color)
            )
            .frame(width: diameter, height: diameter)
            .onAppear {
                currentIndex = index
                color = Color(colors.itemForIndex(index)!)
                changeColor()
            }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(index: 0, diameter: 100)
    }
}
