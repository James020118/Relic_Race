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


/*------------
 A class to show a single tile in a maze
 ------------*/

class TileNode: SKSpriteNode {
    //Position
    var row: Int = 0
    var column: Int = 0
    
    //Identifier
    var typeName: String = ""
    
    //Related Node
    var node: GKGridGraphNode
    
    //Saving data required init
    required init?(coder aDecoder: NSCoder) {
        node = GKGridGraphNode(gridPosition: simd_int2(x: 0, y: 0))
        super.init(coder: aDecoder)
    }
    
    //Conveniance init
    init(node: GKGridGraphNode, with textures: TextureSet) {
        self.node = node
        
        //Assign texture based on
        //whether its a wall or floor
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
        //Set position
        let pos = node.gridPosition
        column = Int(pos.x)
        row = Int(pos.y)
        //Optimization
        blendMode = .replace
    }
    
    /* Function that sets a node in its perspective
        grid position in parent */
    //Assigns proper size and tile position
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
