//
//  GameSceneExt.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-05-21.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

// extension to the game scene
// to keep the main scene file clean
extension GameScene {
    
    // in game object generation
    func characterInitialization() {
        monster1 = Monster(texture: SKTexture(image: #imageLiteral(resourceName: "monster.png")), parent: self, number: 1)
        monster1.name = "monster1"
        monster2 = Monster(texture: SKTexture(image: #imageLiteral(resourceName: "monster.png")), parent: self, number: 2)
        monster2.name = "monster2"
        
        player1 = Player(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self)
        player1.name = "player1"
        opponent = AI(texture: SKTexture(image: #imageLiteral(resourceName: "monster.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    // reset the game (but without reset monster positions)
    func hittingMonster() {
        player1.position = tileManager.tiles[Maze.MAX_ROWS-2][1].position
        player1.updateZoom()
        
        joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
        info.updateHealthPos(newX: player1.position.x + DISPLAY_OFFSET_X, newY: player1.position.y + DISPLAY_OFFSET_Y)
        info.updateScoreLabelPos(newX: player1.position.x - DISPLAY_OFFSET_X, newY: player1.position.y - DISPLAY_OFFSET_Y)
        pause.position = CGPoint(x: player1.position.x, y: player1.position.y + DISPLAY_OFFSET_Y + 35)
    }
    
}
