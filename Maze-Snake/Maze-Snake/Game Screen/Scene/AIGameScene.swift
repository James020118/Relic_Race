//
//  AIGameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import SpriteKit

class AIGameScene: GameScene {
    
    override func sceneDidLoad() {
        initializeGame(type: "ai")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        /* Update the minimap icon positions */
        let dOppT = currentTime - lastOppUpdate
        if dOppT > 0.125 {
            minimap.updateOpponent(position: opponent.position)
            var points = [CGPoint]()
            for monster in monsters {
                points.append(monster.position)
            }
            minimap.updateMonsters(positions: points)
            self.lastOppUpdate = currentTime
        }
    }
}
