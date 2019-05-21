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
    
    /* set trophy random position
       calculate the distance between the trophy and the player
       and the distance between the trophy and the ai
       then choose floor tiles that
       1. have similar distance to both player and the ai
       2. have a distance greater than 8 times the width and height of the tile
    */
    func setRandomPosition() {
        let tile = gameScene.tileManager.getRandomTile(condition: { tile in
            let dx1 = abs(tile.position.x - gameScene.player1.position.x)
            let dx2 = abs(tile.position.x - gameScene.opponent.position.x)
            let dy1 = abs(tile.position.y - gameScene.player1.position.y)
            let dy2 = abs(tile.position.y - gameScene.opponent.position.y)
            return (abs(dx1 - dx2) < tile.frame.width * 7) && (abs(dy1 - dy2) < tile.frame.height * 7) && (dx1 > tile.frame.width * 8) && (dy1 > tile.frame.height * 8)
        })
        position = tile.position
    }
    
}
