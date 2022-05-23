//
//  CalibrationView.swift
//  BalanceBoard
//
//  Created by Pablo Penas on 23/05/22.
//

import SwiftUI
import NavigationStack

struct CalibrationView: View {
    @EnvironmentObject private var nav: NavigationStack
    var body: some View {
        Button(action: {
            nav.push(MenuView())
        }) {
            Text("Play")
        }
    }
}

struct CalibrationView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationView()
    }
}
