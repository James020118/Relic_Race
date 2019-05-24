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
    var playerPos = SKSpriteNode(imageNamed: "oldMan")
    var trophyPos = SKSpriteNode(imageNamed: "Trophyy")
    var opponentPos = SKSpriteNode(imageNamed: "player")
    
    var monstersPos = [SKSpriteNode]()
    
    //Textures for minimap
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: ""),
        wall: SKTexture(imageNamed: "")
    )
    
    //Conveniance init
    init(maze graph: GKGridGraph<GKGridGraphNode>, _ scene: GameScene) {
        tileManager = TileManager(from: graph, with: textureSet)
        tileManager.changeTileColour(
            wall: UIColor(red: 115/255, green: 109/255, blue: 115/255, alpha: 1),
            floor: UIColor(red: 72/255, green: 53/255, blue: 27/255, alpha: 1)
        )
        //Init Tracking Icons
        playerPos.size = CGSize(width: 30, height: 30)
        playerPos.zPosition = 6
        trophyPos.size = CGSize(width: 30, height: 35)
        trophyPos.zPosition = 6
        opponentPos.size = CGSize(width: 30, height: 30)
        opponentPos.zPosition = 6
        for _ in 0..<scene.monsters.count {
            let monsterPos = SKSpriteNode(imageNamed: "monster")
            monsterPos.size = CGSize(width: 30, height: 30)
            monsterPos.zPosition = 6
            monstersPos.append(monsterPos)
        }
        //Call parent init
        let size = CGSize(width: scene.size.width/8, height: scene.size.height/8)
        super.init(texture: nil, color: .black, size: size)
        zPosition = 7
        //Add children to minimap
        scene.addChild(self)
        addChild(playerPos)
        addChild(trophyPos)
        addChild(opponentPos)
        for monsterPos in monstersPos {
            addChild(monsterPos)
        }
        //Init tiles
        tileManager.addTilesTo(scene: self)
        //Update trackable icons
        updatePlayer(position: scene.player1.position)
        updateOpponent(position: scene.opponent.position)
        var points = [CGPoint]()
        for monster in scene.monsters {
            points.append(monster.position)
        }
        updateMonsters(positions: points)
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
    
    func updateMonsters(positions: [CGPoint]) {
        for i in 0..<monstersPos.count {
            update(position: positions[i], property: { point in
                monstersPos[i].position = point
            })
        }
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
