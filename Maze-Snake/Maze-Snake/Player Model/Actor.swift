//
//  Actor.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-08.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class Actor: SKSpriteNode {
    
    var gridPos: CGPoint
    
    static let TILE_TIME = 0.3
    
    init(texture: SKTexture?, parent: GameScene, pos: CGPoint) {
        let WIDTH = parent.frame.width
        let HEIGHT = parent.frame.height
        let size = CGSize(width: WIDTH/CGFloat(Maze.MAX_COLUMNS), height: HEIGHT/CGFloat(Maze.MAX_ROWS))
        self.gridPos = pos
        super.init(texture: texture, color: .clear, size: size)
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gridPos = CGPoint(x: 0, y: 0)
        super.init(coder: aDecoder)
    }
    
    func movePosition(to direction: Direction) {
        switch direction {
        case .left:
            gridPos.x -= 1
        case .right:
            gridPos.x += 1
        case .up:
            gridPos.y += 1
        case .down:
            gridPos.y -= 1
        }
        
        setPosition()
    }
    
    private func setPosition() {
        if let gameScene = parent as? GameScene {
            let endPos = gameScene.tileManager.getTile(row: Int(gridPos.y), column: Int(gridPos.x)).position
            let action = SKAction.move(to: endPos, duration: Actor.TILE_TIME)
            self.run(action)
        }
    }
    
}
