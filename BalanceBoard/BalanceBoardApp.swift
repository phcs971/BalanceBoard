//
//  BalanceBoardApp.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 16/05/22.
//

import SwiftUI
import NavigationStack

@main
struct BalanceBoardApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            GameView()
            NavigationStackView(transitionType: .custom(.opacity), easing: .easeInOut(duration: 1)) {
                ConnectionView()
//                MenuView()
            }
                
        }
    }
}
