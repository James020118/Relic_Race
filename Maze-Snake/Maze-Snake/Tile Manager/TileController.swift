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
    let column: Int
    let row: Int
}

class TileManager {
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
    
    func indexFrom(position: CGPoint) -> GridPosition {
        var row = 0
        var column = 0
        
        for y in 0..<tiles.count {
            for x in 0..<tiles[y].count {
                if tiles[y][x].contains(position) {
                    column = x
                    row = y
                }
            }
        }
        
        return GridPosition(column: column, row: row)
    }
    
    func getTile(row: Int, column: Int) -> TileNode {
        return tiles[column][row]
    }
    
    func path(from tile1: TileNode, to tile2: TileNode) {
        graph.findPath(from: tile1.node, to: tile2.node)
    }
    
    func isWall(row: Int, column: Int) -> Bool {
        let tile = getTile(row: row, column: column)
        let node = tile.node
        let connections = node.connectedNodes.count
        return connections <= 0
    }
    
}
