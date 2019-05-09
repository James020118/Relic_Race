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
    
    //COLUMN - X
    //ROW - Y
    var gridPos: GridPosition
    
    static let TILE_TIME = 0.3
    
    init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        let WIDTH = parent.frame.width
        let HEIGHT = parent.frame.height
        let size = CGSize(width: WIDTH/CGFloat(Maze.MAX_COLUMNS), height: HEIGHT/CGFloat(Maze.MAX_ROWS))
        self.gridPos = pos
        super.init(texture: texture, color: .clear, size: size)
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gridPos = GridPosition(column: 0, row: 0)
        super.init(coder: aDecoder)
    }
    
    func stop() {
        self.removeAllActions()
    }
    
    func movePosition(to direction: Direction) {
        guard let gameScene = parent as? GameScene else {
            return
        }
        
        switch direction {
        case .left:
            gridPos.column -= 1
        case .right:
            gridPos.column += 1
        case .up:
            gridPos.row += 1
        case .down:
            gridPos.row -= 1
        }
        
        if !gameScene.tileManager.isWall(row: gridPos.row, column: gridPos.column) {
            setPosition()
        }
    }
    
    private func setPosition() {
        if let gameScene = parent as? GameScene {
            let endPos = gameScene.tileManager.getTile(row: gridPos.row, column: gridPos.column).position
            let action = SKAction.move(to: endPos, duration: Actor.TILE_TIME)
            self.run(action)
        }
    }
    
}
