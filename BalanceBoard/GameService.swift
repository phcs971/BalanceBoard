//
//  GameService.swift
//  BalanceBoard
//
//  Created by Pedro Henrique Cordeiro Soares on 23/05/22.
//

import Foundation

class GameService {
    private init() { }
    
    static let instace = GameService()
    
    let store = NSUbiquitousKeyValueStore()
    
    var highScore: Int {
        get { Int(store.longLong(forKey: "GER_HighScore")) }
        set { store.set(newValue, forKey: "GER_HighScore") }
    }
    
    var highTime: Int {
        get { Int(store.longLong(forKey: "GER_HighTime")) }
        set { store.set(newValue, forKey: "GER_HighTime") }
    }
    
    var time: String {
        let (min, sec) = highTime.quotientAndRemainder(dividingBy: 60)
        return "\(String(min).leftPadding(toLength: 2, withPad: "0")):\(String(sec).leftPadding(toLength: 2, withPad: "0"))"
    }
    
    func completeGame(score: Int, time: Int) {
        if (score >= highScore) {
            highScore = score
            if (time > highTime) { highTime = time }
        }
    }
}
