//
//  AIGameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase

class AIGameScene: GameScene {
    var db: Firestore!
    let currentUser = Auth.auth().currentUser!
    
    var allUserData = [String : Any]()
    
    var difficulty = Difficulty.Easy
    
    //Database data
    var easyTime = [Int]()
    var hardTime = [Int]()
    var impossibleTime = [Int]()
    var currency = 0
    
    
    var time = 0
    var timer = Timer()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        db = Firestore.firestore()
        
        info.setUpTimerLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.time += 1
            self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
        })
        
        
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.allUserData = document.data()!
                print("Finally retrieved")
                
                let nsEasy = self.allUserData["easyTime"] as? [NSNumber] ?? []
                for num in nsEasy {
                    self.easyTime.append(num.intValue)
                }
                let nsHard = self.allUserData["hardTime"] as? [NSNumber] ?? []
                for num in nsHard {
                    self.hardTime.append(num.intValue)
                }
                let nsImpossible = self.allUserData["impossibleTime"] as? [NSNumber] ?? []
                for num in nsImpossible {
                    self.impossibleTime.append(num.intValue)
                }
                self.currency = self.allUserData["currency"] as! Int
            }
        }
        
    }
    
    override func playerWin() {
        timer.invalidate()
        saveTime()
        super.playerWin()
    }
    
    override func checkMonsterWin() {
        timer.invalidate()
        super.checkMonsterWin()
    }
    
    override func checkOpponentWin() {
        if opponent.score >= 5 {
            timer.invalidate()
        }
        super.checkOpponentWin()
    }
    
    override func playerToTrophyResponse() {
        super.playerToTrophyResponse()
        
        currency += 1
        allUserData["currency"] = currency
        
        db.collection("users").document(currentUser.email!).setData(allUserData) { err in
            if let err = err {
                print("Error adding currency to firestore: \(err)")
            } else {
                print("Currency successfully increased!")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        //Detect touch on pause node
        if node.name == "pause" {
            if isPausing {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.time += 1
                    self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
                })
            } else {
                timer.invalidate()
            }
        }
        
        if node.name == "tryagain" {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.time += 1
                self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
            })
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func generateOpponent() {
        opponent = AI(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        info.timerLabel.position = CGPoint(x: player1.position.x, y: player1.position.y + info.TIMER_OFFSET_Y)
    }
    
    func formattedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(time))!
        
        return formattedString
    }
    
    func saveTime() {
        switch difficulty {
        case .Easy:
            easyTime.append(time)
        case .Hard:
            hardTime.append(time)
        case .Impossible:
            impossibleTime.append(time)
        }
        
        allUserData["easyTime"] = easyTime
        allUserData["hardTime"] = hardTime
        allUserData["impossibleTime"] = impossibleTime
        
        db.collection("users").document(currentUser.email!).setData(allUserData) { err in
            if let err = err {
                print("Error writing time to firestore: \(err)")
            } else {
                print("Time successfully added!")
            }
        }
    }
    
}
