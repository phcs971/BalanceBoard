//
//  GameManager.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 20/05/22.
//

import SwiftUI

enum GameStatus {
    case notStarted
    case started
    case paused
    case ended
}

class GameManager: ObservableObject {
    let scene = GameScene()
    
    var timer: Timer?
    
    init() {
        self.scene.manager = self
        startGame()
    }
    
    func startGame() {
        status = .started
        secondsPassed = 0
        points = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    @Published var status = GameStatus.notStarted
    @Published var points = 0
    var secondsPassed = 0 { didSet { updateTimerString() } }
    @Published var timerString = "00:00"
    
    @objc func onTimer() {
        if status == .started {
            secondsPassed += 1
        }
    }
    
    func updateTimerString() {
        let (min, sec) = secondsPassed.quotientAndRemainder(dividingBy: 60)
        timerString = "\(String(min).leftPadding(toLength: 2, withPad: "0")):\(String(sec).leftPadding(toLength: 2, withPad: "0"))"
    }
    
    func addPoint() {
        points += 1
    }
    
    func endGame() {
        print("GAME OVER")
        timer?.invalidate()
        status = .ended
        scene.isPaused = true
        scene.view?.isPaused = true
    }
}
