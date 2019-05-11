//
//  MiniMapNode.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-09.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MiniMapNode: SKSpriteNode {
    var tileManager: TileManager
    
    var playerPos = SKShapeNode(circleOfRadius: 10)
    
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "Sand_Grid_Center"),
        wall: SKTexture(imageNamed: "Water_Grid_Center")
    )
    
    init(maze graph: GKGridGraph<GKGridGraphNode>, _ scene: GameScene) {
        tileManager = TileManager(from: graph, with: textureSet)
        playerPos.fillColor = .red
        playerPos.zPosition = 6
        let size = CGSize(width: scene.size.width/10, height: scene.size.height/10)
        super.init(texture: nil, color: .black, size: size)
        scene.addChild(self)
        addChild(playerPos)
        tileManager.addTilesTo(scene: self)
        updatePlayer(position: scene.player1.position)
        zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        tileManager = TileManager(from: blankGraph(), with: TextureSet(floor: SKTexture(imageNamed: ""), wall: SKTexture(imageNamed: "")))
        super.init(coder: aDecoder)
    }
    
    func updatePlayer(position: CGPoint) {
        guard let scene = parent as? GameScene else {
            return
        }
        
        let gridPos = scene.tileManager.indexFrom(position: position)
        let newPos = tileManager.getTile(row: gridPos.column, column: gridPos.row).position
        playerPos.position = newPos
    }
    
}
