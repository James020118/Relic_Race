//
//  Opponent.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class Opponent: Actor {
    
    var score = 0
    
    override init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        super.init(texture: texture, parent: parent, pos: pos)
        zPosition = 1
        // AI spawn point: bottom right corner of the maze
        position = parent.tileManager.tiles[1][Maze.MAX_COLUMNS-2].position
        gridPos = GridPosition(column: Maze.MAX_COLUMNS-2, row: 1)
        
        // create physics body for the player
        physicsBody = SKPhysicsBody(circleOfRadius: frame.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0
        physicsBody?.categoryBitMask = playerCategory
        physicsBody?.contactTestBitMask = trophyCategory
        physicsBody?.collisionBitMask = trophyCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func incrementScore() {
        score += 1
    }
}
