//
//  Monster.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-15.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Monster: Actor {
    
    static let TILE_TRAVEL_TIME = 0.5
    
    var number: Int = 0
    
    init(texture: SKTexture, parent: GameScene, number: Int) {
        self.number = number
        super.init(texture: texture, parent: parent, pos: GridPosition(column: 0, row: 0))
        spawn()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* Function that initializes the Monster */
    func spawn() {
        //Visual init of properties here
        zPosition = 1
        
        //Create physics body for the monster
        physicsBody = SKPhysicsBody(circleOfRadius: frame.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0
        physicsBody?.categoryBitMask = monsterCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = playerCategory
        
        //Start Path action
        run(generatePath())
    }
    
    
    /* Spawn the monster in random floor tile */
    func setRandomPosition(num: Int) -> GKGridGraphNode{
        guard let scene = parent as? GameScene else {
            return GKGridGraphNode(gridPosition: simd_int2(x: 0, y: 0))
        }
        
        let tm = scene.tileManager!
        //TODO:- Fix Tile Spawning
        //NOTE: SOMETHING WRONG WITH GRAPH GENERATION? AND CONNECTED NODES
        let rand = tm.getRandomTile(condition: { tile in
            let right_bound = scene.frame.midX + tile.frame.width * 2
            let left_bound = scene.frame.midX - tile.frame.width * 2
            let top_bound = scene.frame.midY + tile.frame.height * 2
            let bottom_bound = scene.frame.midY - tile.frame.height * 2
            switch num {
            case 1:
                return tile.node.connectedNodes.count > 2 && tile.position.x > right_bound && tile.position.y > top_bound
            case 2:
                return tile.node.connectedNodes.count > 2 && tile.position.x < left_bound && tile.position.y > top_bound
            case 3:
                return tile.node.connectedNodes.count > 2 && tile.position.x < left_bound && tile.position.y < bottom_bound
            case 4:
                return tile.node.connectedNodes.count > 2 && tile.position.x > right_bound && tile.position.y < bottom_bound
            default:
                return tile.node.connectedNodes.count > 2
            }
            
        })
        
        gridPos = GridPosition(from: rand.node.gridPosition)
        position = rand.position
        
//        print("Monsters Position: ")
//        print(gridPos)
        return rand.node
    }
    
    
    /* Create Infinitely Repeating Path for Monster */
    func generatePath() -> SKAction {
        guard let scene = parent as? GameScene else {
            return SKAction()
        }
        
        //Navigate through nodes in random directions to generate path
        let oNode = setRandomPosition(num: number)
        var path1 = [oNode]
        var path2 = [oNode]
        var firstDirection: GKGridGraphNode!
        //First Path
        for counter in 1...5 {
            let node = path1.last!
            var connectedNodes = node.connectedNodes
            //Prevent chance of going back and forth
            var i = 0
            while i < connectedNodes.count {
                for traveredNode in path1 {
                    if connectedNodes[i] == traveredNode {
                        connectedNodes.remove(at: i)
                        i -= 1
                        break
                    }
                }
                i += 1
            }
            //In case of dead end
            if connectedNodes.isEmpty {
                firstDirection = GKGridGraphNode(gridPosition: simd_int2(x: -1, y: -1))
                break
            }
            //Add new random node to path
            let newNode = connectedNodes.randomElement()! as! GKGridGraphNode
            if counter == 1 {
                firstDirection = newNode
            }
            path1.append(newNode)
        }
        //Second Path
        for counter in 1...5 {
            let node = path2.last!
            var connectedNodes = node.connectedNodes
            //Remove Possibility of Traversing First Path
            if counter == 1 {
                for index in 0..<connectedNodes.count {
                    if connectedNodes[index] == firstDirection {
                        connectedNodes.remove(at: index)
                        break
                    }
                }
            }
            //Prevent chance of going back and forth
            var i = 0
            while i < connectedNodes.count {
                for traversedNode in path2 {
                    if connectedNodes[i] == traversedNode {
                        connectedNodes.remove(at: i)
                        i -= 1
                        break
                    }
                }
                i += 1
            }
            //In case of dead end
            if connectedNodes.isEmpty {
                break
            }
            //Add new random node to path
            let newNode = connectedNodes.randomElement()
            path2.append(newNode! as! GKGridGraphNode)
        }
        
        //Generate Full Monsters Path
        var path = path1
        path += path1.reversed()
        path += path2
        path += path2.reversed()
        
        //Once path of nodes is given, convert to grid position, then [action]
        var actions = [SKAction]()
        for node in path {
            let gridPos = GridPosition(from: node.gridPosition)
            let newPos = scene.tileManager.getTile(row: gridPos.row, column: gridPos.column).position
            let action = SKAction.move(to: newPos, duration: Monster.TILE_TRAVEL_TIME)
            actions.append(action)
        }
        
        //Create action sequence with given [action] repeating
        let pathAction = SKAction.sequence(actions)
        return SKAction.repeatForever(pathAction)
    }
    
}
