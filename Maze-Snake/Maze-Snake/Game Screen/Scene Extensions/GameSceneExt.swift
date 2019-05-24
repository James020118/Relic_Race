//
//  GameSceneExt.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-05-21.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

/* Extension file to the game scene
To keep the main scene file clean */
extension GameScene {
    
    //Texture initialization
    func textureInitialization() {
        //Walking down texture initializaiton
        walking_Down_TextureAtlas = SKTextureAtlas(named: "walkingDown")
        for i in 1...walking_Down_TextureAtlas.textureNames.count {
            let name = "walking_down_\(i)"
            walking_Down_Textures.append(walking_Down_TextureAtlas.textureNamed(name))
        }
        
        //Walking left texture initialization
        walking_Left_TextureAtlas = SKTextureAtlas(named: "walkingLeft")
        for i in 1...walking_Left_TextureAtlas.textureNames.count {
            let name = "walking_left_\(i)"
            walking_Left_Textures.append(walking_Left_TextureAtlas.textureNamed(name))
        }
        
        //Walking up texture initialization
        walking_Up_TextureAtlas = SKTextureAtlas(named: "walkingUp")
        for i in 1...walking_Up_TextureAtlas.textureNames.count {
            let name = "walking_up_\(i)"
            walking_Up_Textures.append(walking_Up_TextureAtlas.textureNamed(name))
        }
        
        //Walking right texture initialization
        walking_Right_TextureAtlas = SKTextureAtlas(named: "walkingRight")
        for i in 1...walking_Right_TextureAtlas.textureNames.count {
            let name = "walking_right_\(i)"
            walking_Right_Textures.append(walking_Right_TextureAtlas.textureNamed(name))
        }
    }
    
    //In game object generation
    func characterInitialization() {
        let texture = SKTexture(image: #imageLiteral(resourceName: "monster.png"))
        for counter in 1...Monster.MAX_MONSTERS {
            let monster = Monster(texture: texture, parent: self, number: counter)
            monster.name = "monster\(counter)"
            monsters.append(monster)
        }
        
        
        player1 = Player(texture: SKTexture(image: #imageLiteral(resourceName: "oldMan.png")), parent: self)
        player1.name = "player1"
        opponent = AI(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    //Reset player's position after the player runs into a monster (but without reset monster positions)
    func hittingMonster() {
        player1.position = tileManager.tiles[Maze.MAX_ROWS-2][1].position
        player1.updateZoom()
        minimap.updatePlayer(position: player1.position)
        
        joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
        info.updateHealthPos(newX: player1.position.x + DISPLAY_OFFSET_X, newY: player1.position.y + DISPLAY_OFFSET_Y)
        info.updateScoreLabelPos(newX: player1.position.x - DISPLAY_OFFSET_X, newY: player1.position.y - DISPLAY_OFFSET_Y)
        pause.position = CGPoint(x: player1.position.x, y: player1.position.y + DISPLAY_OFFSET_Y + 35)
    }
    
    //Reset the game after user decides to try again after died
    func resetGameAfterPlayerDied() {
        player1.player_Score = 0
        player1.player_Health = 3
        opponent.AI_Score = 0
        
        info.removePlayerDiedDisplay()
        info.changeHealth(healthPoint: player1.player_Health)
        joystick.disabled = false
        
        opponent.position = tileManager.tiles[1][Maze.MAX_COLUMNS-2].position
        opponent.gridPos = GridPosition(column: Maze.MAX_COLUMNS-2, row: 1)
        
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.moveShortestPath(to: trophyGridPos)
        pause.isHidden = false
        
        for monster in monsters {
            monster.run(monster.generatePath())
        }
    }
    
    //Pause all characters except for the player
    func pauseCharacters(bool: Bool) {
        opponent.isPaused = bool
        for monster in monsters {
            monster.isPaused = bool
        }
    }
    
    func initializeHudPositions() {
        if !joystick_On_The_Right {
            JOYSTICK_X_OFFSET = JOYSTICK_X_OFFSET * -1
            LABEL_OFFSET_X = LABEL_OFFSET_X * -1
        }
        
        if !minimap_On_The_Left {
            MINIMAP_OFFSET_X = MINIMAP_OFFSET_X * -1
            DISPLAY_OFFSET_X = DISPLAY_OFFSET_X * -1
        }
        
        joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
        info.updateHealthPos(newX: player1.position.x + DISPLAY_OFFSET_X, newY: player1.position.y + DISPLAY_OFFSET_Y)
        info.updateScoreLabelPos(newX: player1.position.x - DISPLAY_OFFSET_X, newY: player1.position.y - DISPLAY_OFFSET_Y)
    }
    
    //Triggered in the settings
    //Move joystick based on user's selection(left or right)
    func moveJoystick(toTheRight: Bool) {
        if toTheRight {
            info.moveJoystick_Right.fontColor = UIColor.green
            info.moveJoystck_Left.fontColor = UIColor.white
            joystick_On_The_Right = true
            if JOYSTICK_X_OFFSET < 0 {
                JOYSTICK_X_OFFSET = JOYSTICK_X_OFFSET * -1
            }
            if LABEL_OFFSET_X < 0 {
                LABEL_OFFSET_X = LABEL_OFFSET_X * -1
            }
            joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
            info.playerScoreLabel.position = CGPoint(x: player1.position.x - LABEL_OFFSET_X, y: player1.position.y - LABEL_OFFSET_Y)
            info.AIScoreLabel.position = CGPoint(x: player1.position.x - LABEL_OFFSET_X, y: player1.position.y - LABEL_OFFSET_Y - 50)
        } else {
            info.moveJoystick_Right.fontColor = UIColor.white
            info.moveJoystck_Left.fontColor = UIColor.green
            joystick_On_The_Right = false
            if JOYSTICK_X_OFFSET > 0 {
                JOYSTICK_X_OFFSET = JOYSTICK_X_OFFSET * -1
            }
            if LABEL_OFFSET_X > 0 {
                LABEL_OFFSET_X = LABEL_OFFSET_X * -1
            }
            joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
            info.playerScoreLabel.position = CGPoint(x: player1.position.x - LABEL_OFFSET_X, y: player1.position.y - LABEL_OFFSET_Y)
            info.AIScoreLabel.position = CGPoint(x: player1.position.x - LABEL_OFFSET_X, y: player1.position.y - LABEL_OFFSET_Y - 50)
        }
        data.set(joystick_On_The_Right, forKey: "joystickPos")
        print(data.object(forKey: "joystickPos") as! Bool)
    }
    
    func moveMinimap(toTheRight: Bool) {
        if toTheRight {
            info.moveMap_Right.fontColor = UIColor.green
            info.moveMap_Left.fontColor = UIColor.white
            minimap_On_The_Left = false
            if MINIMAP_OFFSET_X > 0 {
                MINIMAP_OFFSET_X = MINIMAP_OFFSET_X * -1
            }
            if DISPLAY_OFFSET_X > 0 {
                DISPLAY_OFFSET_X = DISPLAY_OFFSET_X * -1
            }
            minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
            info.updateHealthPos(newX: player1.position.x + DISPLAY_OFFSET_X, newY: player1.position.y + DISPLAY_OFFSET_Y)
        } else {
            info.moveMap_Right.fontColor = UIColor.white
            info.moveMap_Left.fontColor = UIColor.green
            minimap_On_The_Left = true
            if MINIMAP_OFFSET_X < 0 {
                MINIMAP_OFFSET_X = MINIMAP_OFFSET_X * -1
            }
            if DISPLAY_OFFSET_X < 0 {
                DISPLAY_OFFSET_X = DISPLAY_OFFSET_X * -1
            }
            minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
            info.updateHealthPos(newX: player1.position.x + DISPLAY_OFFSET_X, newY: player1.position.y + DISPLAY_OFFSET_Y)
        }
        data.set(minimap_On_The_Left, forKey: "minimapPos")
        print(data.object(forKey: "minimapPos") as! Bool)
    }
    
}
