//
//  ScoreboardView.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 23/05/22.
//

import SwiftUI

struct ScoreboardView: View {
    let title: String
    let value: String
    let screenWidth: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: screenWidth / 45, weight: .bold, design: .default))
                .foregroundColor(.white)
            Text(value)
                .font(.system(size: screenWidth / 35, weight: .light, design: .default))
                .foregroundColor(.white)
        }
        .padding(.horizontal, screenWidth / 30)
        .padding(.vertical, 4)
        .frame(minWidth: screenWidth / 6.5)
        .background(RoundedRectangle(cornerRadius: .infinity).stroke(Color.white, lineWidth: 1))
        .background(Color.black)
        .cornerRadius(.infinity)
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView(title: "TIME", value: "00:00", screenWidth: UIScreen.main.bounds.width)
    }
}
