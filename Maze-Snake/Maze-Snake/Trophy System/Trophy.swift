//
//  Trophy.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-13.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class Trophy: SKSpriteNode {
    
    let gameScene: GameScene
    
    init(texture: SKTexture, scene: GameScene) {
        gameScene = scene
        let width: CGFloat = gameScene.size.width / CGFloat(Maze.MAX_COLUMNS)
        let height: CGFloat = gameScene.size.height / CGFloat(Maze.MAX_ROWS)
        let size = CGSize(width: width, height: height)
        super.init(texture: texture, color: .blue, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: 50)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = trophyCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = playerCategory
        name = "trophy"
        spawn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        gameScene = GameScene(size: CGSize(width: 0, height: 0))
        super.init(coder: aDecoder)
    }
    
    func spawn() {
        gameScene.addChild(self)
        zPosition = 6
        setRandomPosition()
    }
    
    func setRandomPosition() {
        let tile = gameScene.tileManager.getRandomTile()
        position = tile.position
    }
    
    //TODO: Add contact bitmask with player that
        //respawns trophy to new position
    
}
