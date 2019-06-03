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

/*------------
 A class to manage a system of grid-based tiles
 (Alternative for TileMap)
 ------------*/

class TileManager {
    //A 2-D Array of tiles that represents a cell node
    //tiles[y][x]
    var tiles = [[TileNode]]()
    
    //Graph of maze
    let graph: GKGridGraph<GKGridGraphNode>
    
    //Constant used to control block size for camera zoom
    let ZOOM_CONSTANT: CGFloat = 0.085
    
    var scene: SKNode!
    
    //Conveniance Init
    init(from graph: GKGridGraph<GKGridGraphNode>, with textures: TextureSet) {
        self.graph = graph
        let nodes = graph.nodes as? [GKGridGraphNode] ?? []
        
        if nodes.isEmpty { return }
        
        //Create all tile nodes based on maze graph
        var counter = 0
        for i in 0..<Maze.MAX_ROWS {
            tiles.append([])
            for _ in 0..<Maze.MAX_COLUMNS {
                tiles[i].append(TileNode(node: nodes[counter], with: textures))
                counter += 1
            }
        }
        
    }
    
    
    /* Function that adds all tiles to parent scene */
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
        
        self.scene = scene
    }
    
    
    /* Function that retreives the grid-based
        coordinates from a position in the parent */
    func indexFrom(position: CGPoint) -> GridPosition {
        //Constants in equation
        let WIDTH = scene.frame.width
        let HEIGHT = scene.frame.height
        let NODE_X = tiles.first!.first!.size.width/2
        let NODE_Y = tiles.first!.first!.size.height/2
        //Calculating x positions based on screen ratios
        let ratioX = position.x + WIDTH/2 - NODE_X
        let unroundedX = CGFloat(Maze.MAX_COLUMNS)*(ratioX) / WIDTH
        let column = Int(unroundedX.rounded())
        //Calculating y positions based on screen ratios
        let ratioY = position.y + HEIGHT/2 - NODE_Y
        let unroundedY = CGFloat(Maze.MAX_ROWS)*(ratioY) / HEIGHT
        let row = Int(unroundedY.rounded())
        
        return GridPosition(column: column, row: row)
    }
    
    
    /* Function that adds physics body walls to all walls */
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
    
    /* Function that replaces textures with a colour */
    func changeTileColour(wall wColour: UIColor, floor fColour: UIColor) {
        for y in 0..<tiles.count {
            for tile in tiles[y] {
                tile.texture = nil
                if tile.node.connectedNodes.count == 0 {
                    tile.color = wColour
                }else {
                    tile.color = fColour
                }
                
            }
        }
    }
    
    /* Function that retreives the tiles at
        a given grid-position */
    func getTile(row: Int, column: Int) -> TileNode {
        return tiles[row][column]
    }
    
    
    /* Function that retreives a random floor tile */
    func getRandomTile(condition: (TileNode)-> Bool = { _ in return true }) -> TileNode {
        var spaces = [TileNode]()
        for rows in tiles {
            for tile in rows {
                
                if tile.typeName == "space" {
                    if condition(tile) {
                        spaces.append(tile)
                    }
                }
                
            }
        }
        return spaces.randomElement() ?? tiles[1][1]
    }
    
    //MARK:- OPTIMIZATION
    
    //TODO: Remove all game nodes from parent when game moves to pause/end screen
    
    //TODO: Reduce number of draw calls
    
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
