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

/*------------
 A class to show a minimap for the game
 ------------*/

class MiniMapNode: SKSpriteNode {
    var tileManager: TileManager
    
    //Trackable Player Icons
    var playerPos = SKSpriteNode(imageNamed: "player")
    var trophyPos = SKSpriteNode(imageNamed: "Trophyy")
    var opponentPos = SKSpriteNode(imageNamed: "player")
    
    var monsterPos1 = SKSpriteNode(imageNamed: "monster")
    var monsterPos2 = SKSpriteNode(imageNamed: "monster")
    var monsterPos3 = SKSpriteNode(imageNamed: "monster")
    var monsterPos4 = SKSpriteNode(imageNamed: "monster")
    
    //Textures for minimap
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "Sand_Grid_Center"),
        wall: SKTexture(imageNamed: "Water_Grid_Center")
    )
    
    //Conveniance init
    init(maze graph: GKGridGraph<GKGridGraphNode>, _ scene: GameScene) {
        tileManager = TileManager(from: graph, with: textureSet)
        //Init Tracking Icons
        playerPos.size = CGSize(width: 30, height: 30)
        playerPos.zPosition = 6
        trophyPos.size = CGSize(width: 30, height: 35)
        trophyPos.zPosition = 6
        opponentPos.size = CGSize(width: 30, height: 30)
        opponentPos.zPosition = 6
        
        monsterPos1.size = CGSize(width: 30, height: 30)
        monsterPos1.zPosition = 6
        monsterPos2.size = CGSize(width: 30, height: 30)
        monsterPos2.zPosition = 6
        monsterPos3.size = CGSize(width: 30, height: 30)
        monsterPos3.zPosition = 6
        monsterPos4.size = CGSize(width: 30, height: 30)
        monsterPos4.zPosition = 6
        
        //Call parent init
        let size = CGSize(width: scene.size.width/8, height: scene.size.height/8)
        super.init(texture: nil, color: .black, size: size)
        zPosition = 7
        //Add children to minimap
        scene.addChild(self)
        addChild(playerPos)
        addChild(trophyPos)
        addChild(opponentPos)
        addChild(monsterPos1)
        addChild(monsterPos2)
        addChild(monsterPos3)
        addChild(monsterPos4)
        //Init tiles
        tileManager.addTilesTo(scene: self)
        //Update trackable icons
        updatePlayer(position: scene.player1.position)
        updateOpponent(position: scene.opponent.position)
        updateMonster(position: scene.monster1.position)
        updateMonster2(position: scene.monster2.position)
        updateMonster3(position: scene.monster3.position)
        updateMonster4(position: scene.monster4.position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tileManager = TileManager(from: blankGraph(), with: TextureSet(floor: SKTexture(imageNamed: ""), wall: SKTexture(imageNamed: "")))
        super.init(coder: aDecoder)
    }
    
    /* Functions to update trackable icons */
    
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
    func updateMonster(position: CGPoint) {
        update(position: position, property: { point in
            monsterPos1.position = point
        })
    }
    func updateMonster2(position: CGPoint) {
        update(position: position, property: { point in
            monsterPos2.position = point
        })
    }
    func updateMonster3(position: CGPoint) {
        update(position: position, property: { point in
            monsterPos3.position = point
        })
    }
    func updateMonster4(position: CGPoint) {
        update(position: position, property: { point in
            monsterPos4.position = point
        })
    }
    
    //Function to update a generic SKShapeNode's position
    func update(position: CGPoint, property: (CGPoint) -> Void) {
        guard let scene = parent as? GameScene else {
            return
        }
        
        let gridPos = scene.tileManager.indexFrom(position: position)
        let newPos = tileManager.getTile(row: gridPos.row, column: gridPos.column).position
        property(newPos)
    }
    
}
