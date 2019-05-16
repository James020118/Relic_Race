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
    
    func generatePath() {
        guard let scene = parent as? GameScene else {
            return
        }
        
        //TODO:- Navigate through nodes in random directions to generate path
        var nodes = scene.tileManager!.graph.nodes ?? []
        var path = [setRandomPosition()]
        for i in 0...5 {
            let node = path.last!
            let connectedNodes = node.connectedNodes
            let newNode = connectedNodes.randomElement()
            //path.append(newNode!)
        }
        
        //TODO:- Once path of nodes is given,
            //convert to grid position, then [action]
        
        //TODO:- Create action sequence with [given [action], [action].reversed()] repeating
    }
    
}
