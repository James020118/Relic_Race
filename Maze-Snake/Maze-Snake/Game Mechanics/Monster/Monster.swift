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
    
    init(texture: SKTexture, parent: GameScene) {
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
//        physicsBody?.categoryBitMask = playerCategory
//        physicsBody?.contactTestBitMask = trophyCategory
//        physicsBody?.collisionBitMask = trophyCategory
        
        //Start Path action
        run(generatePath())
    }
    
    /* Spawn the monster in random floor tile */
    func setRandomPosition() -> GKGridGraphNode{
        guard let scene = parent as? GameScene else {
            return GKGridGraphNode(gridPosition: simd_int2(x: 0, y: 0))
        }
        
        let tm = scene.tileManager!
        let rand = tm.getRandomTile(condition: { tile in
            return tile.node.connectedNodes.count > 2
        })
        
        gridPos = GridPosition(from: rand.node.gridPosition)
        position = rand.position
        
        return tm.getTile(row: 1, column: 1).node//rand.node
    }
    
    /* Create Infinitely Repeating Path for Monster */
    func generatePath() -> SKAction {
        guard let scene = parent as? GameScene else {
            return SKAction()
        }
        
        //Navigate through nodes in random directions to generate path
        var path = [setRandomPosition()]
        for _ in 0...8 {
            let node = path.last!
            var connectedNodes = node.connectedNodes
            var fIndex = -1
            for i in 0..<connectedNodes.count {
                if node == connectedNodes[i] {
                    fIndex = i
                }
            }
            if fIndex != -1 {
                connectedNodes.remove(at: fIndex)
            }
            let newNode = connectedNodes.randomElement()
            path.append(newNode! as! GKGridGraphNode)
        }
        
        //Once path of nodes is given, convert to grid position, then [action]
        var actions = [SKAction]()
        for node in path {
            let gridPos = GridPosition(from: node.gridPosition)
            let newPos = scene.tileManager.getTile(row: gridPos.row, column: gridPos.column).position
            let action = SKAction.move(to: newPos, duration: Monster.TILE_TRAVEL_TIME)
            actions.append(action)
        }
        
        //Create action sequence with [given [action], [action].reversed()] repeating
        actions += actions.reversed()
        let pathAction = SKAction.sequence(actions)
        return SKAction.repeatForever(pathAction)
    }
    
}
