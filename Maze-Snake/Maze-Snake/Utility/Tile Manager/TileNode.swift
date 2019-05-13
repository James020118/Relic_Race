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
    
    var typeName: String = ""
    
    var node: GKGridGraphNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(node: GKGridGraphNode, with textures: TextureSet) {
        self.node = node
        
        var texture: SKTexture!
        if node.connectedNodes.count > 0 {
            //Floor
            texture = textures.floor
            typeName = "space"
        }else {
            //Wall
            texture = textures.wall
            typeName = "wall"
        }
        
        super.init(texture: texture, color: .clear, size: CGSize(width: 10, height: 10))
        let pos = node.gridPosition
        column = Int(pos.x)
        row = Int(pos.y)
        blendMode = .replace
    }
    
    
    func setPosition(in scene: SKNode) {
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
