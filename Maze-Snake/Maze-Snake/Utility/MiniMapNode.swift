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
    var trophyPos = SKShapeNode(circleOfRadius: 10)
    var opponentPos = SKShapeNode(circleOfRadius: 10)
    
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "Sand_Grid_Center"),
        wall: SKTexture(imageNamed: "Water_Grid_Center")
    )
    
    init(maze graph: GKGridGraph<GKGridGraphNode>, _ scene: GameScene) {
        tileManager = TileManager(from: graph, with: textureSet)
        
        playerPos.fillColor = .green
        playerPos.zPosition = 6
        trophyPos.fillColor = .yellow
        trophyPos.zPosition = 6
        opponentPos.fillColor = .red
        opponentPos.zPosition = 6
        
        let size = CGSize(width: scene.size.width/8, height: scene.size.height/8)
        super.init(texture: nil, color: .black, size: size)
        
        scene.addChild(self)
        addChild(playerPos)
        addChild(trophyPos)
        addChild(opponentPos)
        
        tileManager.addTilesTo(scene: self)
        updatePlayer(position: scene.player1.position)
        updateOpponent(position: scene.opponent.position)
        zPosition = 7
    }
    
    required init?(coder aDecoder: NSCoder) {
        tileManager = TileManager(from: blankGraph(), with: TextureSet(floor: SKTexture(imageNamed: ""), wall: SKTexture(imageNamed: "")))
        super.init(coder: aDecoder)
    }
    
    
    func updatePlayer(position: CGPoint) {
        update(position: position, property: { point in
            playerPos.position = point
        })
        
    }
    func updateTrophy(position: CGPoint) {
        update(position: position, property: { point in
            trophyPos.position = point
        })
        
    }
    func updateOpponent(position: CGPoint) {
        update(position: position, property: { point in
            opponentPos.position = point
        })
    }
    func update(position: CGPoint, property: (CGPoint) -> Void) {
        guard let scene = parent as? GameScene else {
            return
        }
        
        let gridPos = scene.tileManager.indexFrom(position: position)
        let newPos = tileManager.getTile(row: gridPos.row, column: gridPos.column).position
        property(newPos)
    }
    
}
