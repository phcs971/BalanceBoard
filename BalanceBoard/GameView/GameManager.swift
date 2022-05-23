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
    
    var view: GameView?
    
    var timer: Timer?
    
    init() {
        self.scene.manager = self
        scene.isPaused = true
        scene.view?.isPaused = true
    }
    
    func startLoader() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onLoadTimer), userInfo: nil, repeats: true)
        view?.startLoader()
        
    }
    
    func startGame() {
        status = .started
        secondsPassed = 0
        points = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        scene.addWall()
    }
    
    @Published var status = GameStatus.notStarted {
        didSet {
            switch status {
            case .notStarted:
                opacity = 0.0
                loadProgress = 1.0
                view?.resetLoader()
            case .started:
                scene.isPaused = false
                scene.view?.isPaused = false
                withAnimation(.easeInOut(duration: 0.5)) { opacity = 1.0 }
            case .paused:
                break
            case .ended:
                break
            }
        }
    }
    
    @Published var opacity = 0.0
    @Published var loadProgress = 1.0
    @Published var loadRotation = 0.0
    @Published var loadValue = 3
    @Published var points = 0
    var secondsPassed = 0 { didSet { updateTimerString() } }
    @Published var timerString = "00:00"
    
    @objc func onLoadTimer() {
        loadValue -= 1
        if (loadValue == 0) {
            timer?.invalidate()
            startGame()
        }
    }
    
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
        GameService.instace.completeGame(score: points, time: secondsPassed)
        timer?.invalidate()
        status = .ended
        scene.isPaused = true
        scene.view?.isPaused = true
        view?.endGame()
    }
}
