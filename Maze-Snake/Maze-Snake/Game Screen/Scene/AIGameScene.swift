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

class AIGameScene: GameScene {
    
    var time = 0
    var timer = Timer()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        info.setUpTimerLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.time += 1
            self.info.timerLabel.text = "\(self.time / 60):\(self.time % 60)"
            print(self.time)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        //Detect touch on pause node
        if node.name == "pause" {
            if isPausing {
                timer.invalidate()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.time += 1
                    self.info.timerLabel.text = "\(self.time / 60):\(self.time % 60)"
                    print(self.time)
                })
            }
        }
    }
    
    override func generateOpponent() {
        opponent = AI(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        info.timerLabel.position = CGPoint(x: player1.position.x, y: player1.position.y + info.TIMER_OFFSET_Y)
        
        //Do not know why this block of code doesn't execute
//        if player1.player_Score == 5 || opponent.score == 5 {
//            timer.invalidate()
//            print(timer.isValid)
//        }
    }
    
}
