//
//  AI.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-08.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

var TILE_TIME = 0.2

class AI: Opponent {
    
    override init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        super.init(texture: texture, parent: parent, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func shortestPath(to point: GridPosition) -> [GridPosition] {
        guard let gameScene = parent as? GameScene else {
            return []
        }
        
        let tm = gameScene.tileManager ?? TileManager(from: blankGraph(), with: TextureSet(floor: SKTexture(imageNamed: ""), wall: SKTexture(imageNamed: "")))
        
        let node1 = tm.getTile(row: gridPos.row, column: gridPos.column).node
        let node2 = tm.getTile(row: point.row, column: point.column).node

        let shortestNodes = tm.graph.findPath(from: node1, to: node2)
        
        var positions = [GridPosition]()
        for node in shortestNodes {
            let gridNode = node as? GKGridGraphNode ?? GKGridGraphNode(gridPosition: vector2(0, 0))
            positions.append(GridPosition(from: gridNode.gridPosition))
        }
        
        return positions
    }
    
    func moveShortestPath(to point: GridPosition) {
        guard let gameScene = parent as? GameScene else {
            return
        }
        
        let path = shortestPath(to: point)
        
        var actions = [SKAction]()
        for index in path {
            let newPos = gameScene.tileManager!.getTile(row: index.row, column: index.column).position
            let action = SKAction.move(to: newPos, duration: TILE_TIME)
            actions.append(action)
        }
        
        let comboAction = SKAction.sequence(actions)
        self.run(comboAction)
    }
    
}
