//
//  TileNode.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TileNode: SKSpriteNode {
    
    var row: Int = 0
    var column: Int = 0
    
    var node: GKGridGraphNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(node: GKGridGraphNode) {
        self.node = node
        //TODO: Create texture based on direction of edges
        
        super.init(texture: nil, color: .black, size: CGSize(width: 0, height: 0))
        let pos = node.gridPosition
        row = Int(pos.x)
        column = Int(pos.y)
    }
    
    func setPosition(in scene: GameScene) {
        let WIDTH = scene.frame.width
        let HEIGHT = scene.frame.height
        
        let ufX = CGFloat(row) / CGFloat(Maze.MAX_ROWS) * WIDTH
        let xPos = ufX - WIDTH/2
        let ufY = CGFloat(column) / CGFloat(Maze.MAX_ROWS) * HEIGHT
        let yPos = ufY - HEIGHT/2
        
        position = CGPoint(x: xPos, y: yPos)
    }
    
}
