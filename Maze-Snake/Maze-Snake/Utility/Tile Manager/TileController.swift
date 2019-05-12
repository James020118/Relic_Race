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


class TileManager {
    var tiles = [[TileNode]]()
    let graph: GKGridGraph<GKGridGraphNode>
    
    let ZOOM_CONSTANT: CGFloat = 0.085
    
    init(from graph: GKGridGraph<GKGridGraphNode>, with textures: TextureSet) {
        self.graph = graph
        let nodes = graph.nodes as? [GKGridGraphNode] ?? []
        
        if nodes.isEmpty { return }
        
        var counter = 0
        for i in 0..<Maze.MAX_ROWS {
            tiles.append([])
            for _ in 0..<Maze.MAX_COLUMNS {
                tiles[i].append(TileNode(node: nodes[counter], with: textures))
                counter += 1
            }
        }
        
    }
    
    
    
    func addTilesTo(scene: SKNode) {
        if scene as? GameScene != nil {
            addWallCollisions()
        }
        
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
    
    
    
    private func addWallCollisions() {
        // give boundary to each tile in the tile sets
        for rows in tiles {
            for tiles in rows {
                if tiles.typeName == "wall" {
                    tiles.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tiles.size.width / ZOOM_CONSTANT, height: tiles.size.height / ZOOM_CONSTANT))
                    tiles.physicsBody?.isDynamic = false
                }
            }
        }
    }
    
    
    
    
    func getTile(row: Int, column: Int) -> TileNode {
        return tiles[column][row]
    }
    
    //MARK:- OPTIMIZATION
    
    //TODO: TURN view.shouldCullNonVisibleNodes to false
        //after viewOnScreenTiles() is complete
    
    //TODO: Experiment with atlases
    
    //Remove offscreen nodes from parent and add those in-screen in
    //Removes over 600 nodes but doesn't reduce # of draw calls
    func viewOnScreenTiles(pos: CGPoint, parent: GameScene) {
        let gridPos = indexFrom(position: pos)
        
        var xlow = gridPos.column - 8
        xlow = xlow > 0 ? xlow : 0
        var xHigh = gridPos.column + 8
        xHigh = xHigh < Maze.MAX_COLUMNS ? xHigh : Maze.MAX_COLUMNS-1
        
        var ylow = gridPos.row - 5
        ylow = ylow > 0 ? ylow : 0
        var yHigh = gridPos.row + 5
        yHigh = yHigh < Maze.MAX_ROWS ? yHigh : Maze.MAX_ROWS-1
        
        for y in 0..<tiles.count {
            for x in 0..<tiles[y].count {
                let withinX = x >= xlow && x <= xHigh
                let withinY = y >= ylow && y <= yHigh
                
                let tile = tiles[y][x]
                if !(withinX && withinY) {
                    tile.removeFromParent()
                    continue
                }
                
                if tile.parent == nil {
                    parent.addChild(tile)
                }
                
            }
        }

    }
    
    //TODO: Create bitmap to rasterize minimap
    
}
