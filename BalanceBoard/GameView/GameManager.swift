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

class GameManager: NSObject ,ObservableObject {
    let scene = GameScene()
    
    var view: GameView?
    
    var timer: Timer?
    
    var lastValues = [SensorModel]()
    @Published var currentValue: SensorModel?
    @Published var currentInclination = CGVector(dx: 0, dy: 0)
    private var maximumAngleX: CGFloat = 0
    private var maximumAngleY: CGFloat = 0
    
    var stationaryStateAcc = VectorModel(x: -0.067, y: 0.121, z: 1.017)
    let multi = 10.0
    let min = 0.1
    
    override init() {
        super.init()
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
                scene.resetPosition()
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

extension GameManager: BLEManagerDelegate {
    func onUpdate(_ value: SensorModel) {
        // Inclination update
        if abs(value.acc.x) > maximumAngleX {
            maximumAngleX = abs(value.acc.x)
        }
        if abs(value.acc.y) > maximumAngleY {
            maximumAngleY = abs(value.acc.y)
        }
        withAnimation(.easeInOut(duration: 0.2)) {
            currentInclination = CGVector(dx: -value.acc.x/maximumAngleX, dy: value.acc.y/maximumAngleY)
        }
        
        lastValues.append(value)
        lastValues = lastValues.suffix(2)
        currentValue = lastValues.average
        print(currentValue?.acc.x ?? "SEM X", currentValue?.acc.y ?? "SEM Y", currentValue?.acc.z ?? "SEM Z")
        let va = currentValue!.acc - stationaryStateAcc
        print(va.x, va.y, va.z)
        currentValue = value
        if let v = currentValue?.acc {
            let gravity = (v - stationaryStateAcc)
            
            print(gravity.x, gravity.y, gravity.z)
            print("")
            //            print("")
//            superBallScene.movingBall?.updateVelocity(velocity: CGVector(
//                dx: -v.x * multi * 100,
//                dy: -v.y * multi * 100
//            ))
            scene.physicsWorld.gravity = CGVector(
                dx: abs(gravity.x) > min ? -gravity.x * multi : 0,
                dy: abs(gravity.y) > min ? -gravity.y * multi : 0
            )
//            scene.physicsWorld.gravity = CGVector(
//                dx: value.acc.x,
//                dy: value.acc.y
//            )
        }
    }
}
