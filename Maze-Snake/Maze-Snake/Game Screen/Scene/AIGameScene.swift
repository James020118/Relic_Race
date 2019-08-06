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
    var currentUser = Auth.auth().currentUser
    
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] (_) in
            self.time += 1
            self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
        })
        guard let currentUser = currentUser else {
            return
        }
        if Auth.auth().currentUser!.isAnonymous {
            return
        }
        db.disableNetwork(completion: { [unowned self] error in
            self.requestGameData(from: currentUser)
        })
        
    }
    
    func requestGameData(from currentUser: User) {
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument(source: .cache, completion: { [unowned self] (document, error) in
            if error != nil {
                return
            }
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
                self.currency = self.allUserData["currency"] as? Int ?? 0
            }
        })
    }
    
    override func playerWin() {
        timer.invalidate()
        saveTime()
        
        //Present Ads
        presentAd()
        
        super.playerWin()
        //Save relics gained
        guard let currentUser = currentUser else {
            return
        }
        if Auth.auth().currentUser!.isAnonymous {
            return
        }
        storeToServer(with: currentUser)
    }
    
    override func checkMonsterWin() {
        timer.invalidate()
        
        //Present Ads
        presentAd()
        
        //Save relics gained
        guard let currentUser = currentUser else {
            super.checkMonsterWin()
            return
        }
        if Auth.auth().currentUser!.isAnonymous {
            super.checkMonsterWin()
            return
        }
        storeToServer(with: currentUser)
        
        super.checkMonsterWin()
    }
    
    override func checkOpponentWin() {
        if opponent.score >= 5 {
            timer.invalidate()
            
            //Present Ads
            presentAd()
            
            //Save relics gained
            guard let currentUser = currentUser else {
                super.checkOpponentWin()
                return
            }
            if Auth.auth().currentUser!.isAnonymous {
                super.checkOpponentWin()
                return
            }
            storeToServer(with: currentUser)
        }
        
        super.checkOpponentWin()
    }
    
    override func playerToTrophyResponse() {
        super.playerToTrophyResponse()
        
        currency += 1
        allUserData["currency"] = currency
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        //Detect touch on pause node
        if node.name == "pause" {
            if isPausing {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] (_) in
                    self.time += 1
                    self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
                })
            } else {
                timer.invalidate()
            }
        }
        
        if node.name == "tryagain" {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] (_) in
                self.time += 1
                self.info.timerLabel.text = "Time Spent: " + self.formattedTime()
            })
        }
        
        if node.name == "return" {
            //Save relics gained
            guard let currentUser = currentUser else {
                super.touchesBegan(touches, with: event)
                return
            }
            if Auth.auth().currentUser!.isAnonymous {
                super.touchesBegan(touches, with: event)
                return
            }
            storeToServer(with: currentUser)
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
        var formattedString = formatter.string(from: TimeInterval(time))!
        if time < 60 {
            if time < 10 {
                formattedString = "0" + formattedString
            }
            formattedString = "0:" + formattedString
        }
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
        
        guard let currentUser = currentUser else {
            return
        }
        if Auth.auth().currentUser!.isAnonymous {
            return
        }
        storeToServer(with: currentUser)
    }
    
    func storeToServer(with currentUser: User) {
        db.enableNetwork(completion: { [unowned self] error in
            self.db.collection("users").document(currentUser.email!).setData(self.allUserData, completion: { [unowned self] (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                self.db.disableNetwork(completion: nil)
            })
        })
    }
    
    func presentAd() {
        if let adVC = self.parentVC as? GameViewController {
            if adVC.interstitial.isReady {
                adVC.interstitial.present(fromRootViewController: adVC)
            }
        }
    }
    
}
