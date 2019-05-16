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

class Monster: SKSpriteNode {
    
    static let TILE_TRAVEL_TIME = 0.05
    
    init(texture: SKTexture, parent: GameScene) {
        let size = CGSize(width: 0, height: 0)
        super.init(texture: texture, color: .black, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func spawn() {
        //TODO:- Put visual init of properties here
    }
    
    func setRandomPosition() -> GKGridGraphNode{
        guard let scene = parent as? GameScene else {
            return GKGridGraphNode(gridPosition: simd_int2(x: 0, y: 0))
        }
        
        let tm = scene.tileManager!
        let rand = tm.getRandomTile(condition: { tile in
            return tile.node.connectedNodes.count > 2
        })
        
        position = rand.position
        
        return rand.node
    }
    
    func generatePath() -> SKAction {
        guard let scene = parent as? GameScene else {
            return SKAction()
        }
        
        //Navigate through nodes in random directions to generate path
        var path = [setRandomPosition()]
        for _ in 0...5 {
            let node = path.last!
            let connectedNodes = node.connectedNodes
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
