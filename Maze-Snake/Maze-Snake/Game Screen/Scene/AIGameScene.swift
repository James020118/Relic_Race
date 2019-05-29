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
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func generateOpponent() {
        opponent = AI(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
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
