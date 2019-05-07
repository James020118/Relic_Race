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

struct GridPosition {
    let row: Int
    let column: Int
}

class TileController {
    var tiles = [[TileNode]]()
    let graph: GKGridGraph<GKGridGraphNode>
    
    init(from graph: GKGridGraph<GKGridGraphNode>) {
        self.graph = graph
        let nodes = graph.nodes as? [GKGridGraphNode] ?? []
        
        if nodes.isEmpty { return }
        
        var counter = 0
        for i in 0..<Maze.MAX_ROWS {
            tiles.append([])
            for _ in 0..<Maze.MAX_COLUMNS {
//                print(nodes[counter].gridPosition)
//                print(nodes[counter].connectedNodes)
//                print("")
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
    
    func positionFrom(position: CGPoint) -> GridPosition {
        var row = 0
        var column = 0
        
        for i in 0..<tiles.count {
            for j in 0..<tiles[i].count {
                if tiles[i][j].contains(position) {
                    column = i
                    row = j
                }
            }
        }
        
        return GridPosition(row: row, column: column)
    }
    
    func getTile(row: Int, column: Int) -> TileNode {
        return tiles[column][row]
    }
    
    func path(from tile1: TileNode, to tile2: TileNode) {
        graph.findPath(from: tile1.node, to: tile2.node)
    }
    
}
