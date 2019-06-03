//
//  MazeEncodingBuffer.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

struct GameEncodingBuffer: Codable {
    let tiles: [[String]]
    let paths: [[GridPosition]]
    
    init(from maze: Maze, and monsters: [Monster]) {
        //-- Store Game Map
        var tiles = [[String]]()
        //Convert to encoded format
        for y in 0..<maze.data.count {
            var sub = [String]()
            for x in 0..<maze.data[y].count {
                if maze.data[y][x].cellType == .Wall {
                    sub.append("w")
                }else if maze.data[y][x].cellType == .Space {
                    sub.append("s")
                }
            }
            tiles.append(sub)
        }
        self.tiles = tiles
        
        //-- Store Monsters
        var paths = [[GridPosition]]()
        for monster in monsters {
            paths.append(monster.path)
        }
        self.paths = paths
    }
    
    func getMonsters(from parent: GameScene) -> [Monster] {
        let texture = SKTexture(image: #imageLiteral(resourceName: "monster.png"))
        
        var monsters = [Monster]()
        for i in 0..<paths.count {
            var curMonster = Monster(texture: texture, parent: parent, number: 0)
            curMonster.name = "monster\(i)"
            curMonster.stop()
            var actions = [SKAction]()
            for j in 0..<paths[i].count {
                let point = paths[i][j]
                let pos = parent.tileManager.getTile(row: point.row, column: point.column).position
                if j == 0 { curMonster.position = pos }
                let action = SKAction.move(to: pos, duration: Monster.TILE_TRAVEL_TIME)
                actions.append(action)
            }
            let sequence = SKAction.sequence(actions)
            let action = SKAction.repeatForever(sequence)
            curMonster.run(action)
            monsters.append(curMonster)
        }
        
        return monsters
    }
    
}
