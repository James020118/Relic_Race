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
        
        let directions = node.nodeDirections()
        
        var textureName = ""
        //TODO: Create texture based on direction of edges by making exhaustive switch-case
        switch directions {
        case [.up]:
            textureName = "Grass_Grid_Center"
        default:
            textureName = "Grass_Grid_Center"
        }
        
        super.init(texture: SKTexture(imageNamed: textureName), color: .clear, size: CGSize(width: 10, height: 10))
        let pos = node.gridPosition
        row = Int(pos.y)
        column = Int(pos.x)
    }
    
    func setPosition(in scene: GameScene) {
        let WIDTH = scene.frame.width
        let HEIGHT = scene.frame.height
        
        size = CGSize(width: WIDTH/CGFloat(Maze.MAX_COLUMNS), height: HEIGHT/CGFloat(Maze.MAX_ROWS))
        
        let NODE_X = size.width/2
        let NODE_Y = size.height/2
        
        let ufX = CGFloat(column) / CGFloat(Maze.MAX_COLUMNS)  * WIDTH
        let xPos = ufX - WIDTH/2 + NODE_X
        let ufY = CGFloat(row) / CGFloat(Maze.MAX_ROWS)  * HEIGHT
        let yPos = ufY - HEIGHT/2 + NODE_Y

        position = CGPoint(x: xPos, y: yPos)
        
    }
    
}
