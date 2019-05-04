//
//  TileController.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TileController {
    var tiles = [[TileNode]]()
    let graph: GKGridGraph<GKGridGraphNode>
    
    init(from graph: GKGridGraph<GKGridGraphNode>) {
        self.graph = graph
        let nodes = graph.nodes as? [GKGridGraphNode] ?? []
        
        var counter = 0
        for i in 0...Maze.MAX_COLUMNS {
            tiles.append([])
            for _ in 0...Maze.MAX_ROWS {
                tiles[i].append(TileNode(node: nodes[counter]))
                counter += 1
            }
        }
        
    }
    
    func addTilesTo(scene: GameScene) {
        for row in tiles {
            for tile in row {
                scene.addChild(tile)
                tile.setPosition(in: scene)
            }
        }
    }
    
    func indexFrom(position: CGPoint) -> (Int, Int) {
        var row = -1
        var column = -1
        
        for i in 0..<tiles.count {
            for j in 0..<tiles.count {
                if tiles[i][j].contains(position) {
                    row = i
                    column = j
                }
            }
        }
        
        return (row, column)
    }
    
}
