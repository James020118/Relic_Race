//
//  GameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import SpriteKit
import GameplayKit

//Speed of player
let velocityMultiplier: CGFloat = 0.11
//Contact Identifiers
let playerCategory: UInt32 = 0x1 << 1
let trophyCategory: UInt32 = 0x1 << 2
let monsterCategory: UInt32 = 0x1 << 3

let data = UserDefaults.standard

/*-----------------
 Scene for PvAI Gameplay
 -----------------*/
class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK:- Gameplay Properties
    
    //Object for Sound Effects
    var sfxController: SFXController!
    
    //Graph for Maze
    var mazeGraph: GKGridGraph<GKGridGraphNode>?
    //Manages grid-like tiles
    var tileManager: TileManager!
    //Joystick to control player
    var joystick = AnalogJoystick(diameter: 150)
    
    //Actors
    var player1: Player!
    var opponent: Opponent!
    
    //Monsters
    var monsters = [Monster]()
    
    //Objective
    var trophy: Trophy!
    
    //Real-time Tracking Minimap
    var minimap: MiniMapNode!
    
    //Pause Button
    var pause = SKSpriteNode()
    
    //Display various information
    var info: InfoDisplay!
    
    //HUD Position Offset Constants
    var DISPLAY_OFFSET_X: CGFloat = 625
    var DISPLAY_OFFSET_Y: CGFloat = 375
    var LABEL_OFFSET_X: CGFloat = 600
    var LABEL_OFFSET_Y: CGFloat = 375
    var JOYSTICK_X_OFFSET : CGFloat = 600
    var JOYSTICK_Y_OFFSET : CGFloat = 275
    var MINIMAP_OFFSET_X : CGFloat = 600
    var MINIMAP_OFFSET_Y : CGFloat = 325
    
    //Walking textures
    var walking_Down_TextureAtlas = SKTextureAtlas()
    var walking_Down_Textures = [SKTexture]()
    
    var walking_Left_TextureAtlas = SKTextureAtlas()
    var walking_Left_Textures = [SKTexture]()
    
    var walking_Up_TextureAtlas = SKTextureAtlas()
    var walking_Up_Textures = [SKTexture]()
    
    var walking_Right_TextureAtlas = SKTextureAtlas()
    var walking_Right_Textures = [SKTexture]()
    
    //Textures for maze
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "floor_texture"),
        wall: SKTexture(imageNamed: "wall_texture")
    )
    
    //Parent VC instance
    var parentVC: UIViewController!
    
    
    //MARK:- Lifecycle Functions
    /* Function that is called when scene loads */
    override func sceneDidLoad() {
        SKTextureAtlas(named: "Game_Textures").preload {
            print("Completed")
        }
        
        super.sceneDidLoad()
        initializeGame(type: "ai")
        print("Completed game load")
    }
    
    var isPausing = false
    /* Function that is called when user touches screen */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Get element at touch pos
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        /* Response to User Game Menu Interaction */
        //Detect touch on pause node
        if node.name == "pause" {
            if isPausing {
                info.removePauseGame()
                pauseCharacters(bool: false)
                isPausing = false
            } else {
                info.pauseGame(xCoord: player1.position.x, yCoord: player1.position.y)
                pauseCharacters(bool: true)
                isPausing = true
            }
        }
        
        if node.name == "tryagain" {
            resetGameAfterPlayerDied()
        }
        
        if node.name == "return" || node.name == "exit" {
            removeAllChildren()
            parentVC.dismiss(animated: true, completion: nil)
        }
        
        if node.name == "settings" {
            info.goToSettings(xCoord: player1.position.x, yCoord: player1.position.y)
        }
        
        if node.name == "joystick_right" || node.name == "joystick_left" {
            if node.name == "joystick_right" {
                moveJoystick(toTheRight: true)
            } else {
                moveJoystick(toTheRight: false)
            }
        }
        
        if node.name == "minimap_right" || node.name == "minimap_left" {
            if node.name == "minimap_right" {
                moveMinimap(toTheRight: true)
            } else {
                moveMinimap(toTheRight: false)
            }
        }
        
        if node.name == "back" {
            info.exitSettings()
        }
    }
    
    //For walking animation retrieve direction of motion by storing previous position and compare to present
    var prevPos: CGPoint?
    var prevDir: Direction?
    func selectCorrectWalk(playerPos: CGPoint) -> Direction {
        var currentHeading: Direction = .none
        guard let prevPos = prevPos else {
            self.prevPos = playerPos
            return .none
        }
        let dx = playerPos.x - prevPos.x
        let dy = playerPos.y - prevPos.y
        
        if playerPos == prevPos {
            currentHeading = .none
        }else if abs(dx) > abs(dy) {
            if playerPos.x > prevPos.x {
                currentHeading = .right
            }else if playerPos.x < prevPos.x {
                currentHeading = .left
            }
        }else if abs(dx) <= abs(dy) {
            if playerPos.y > prevPos.y {
                currentHeading = .up
            }else if playerPos.y < prevPos.y {
                currentHeading = .down
            }
        }
        self.prevPos = playerPos
        
        return currentHeading
    }
    
    
    /* Function that is called before each frame is rendered */
    var startUpdateFlag = false
    
    var lastOppUpdate: TimeInterval = 0
    var lastCheck: TimeInterval = 0
    //Flags to detect when there is a meaningful collsion
    var player1CollisionFlag = false
    var opponentCollisionFlag = false
    var monsterCollisionFlag = -1
    override func update(_ currentTime: TimeInterval) {
        /* When a meaningful collision is detected, have an appropriate response */
        if player1CollisionFlag {
            playerCollisionResponse()
        }
        if opponentCollisionFlag {
            opponentCollisionResponse()
        }
        if monsterCollisionFlag != -1 {
           monsterCollisionResponse()
        }
        
        /* Update the minimap icon positions */
        let dOppT = currentTime - lastOppUpdate
        if dOppT > 0.125 {
            if !startUpdateFlag {
                return
            }
            minimap.updateOpponent(position: opponent.position)
            var points = [CGPoint]()
            for monster in monsters {
                points.append(monster.position)
            }
            minimap.updateMonsters(positions: points)
            self.lastOppUpdate = currentTime
        }
        
    }
    
    func initializeGame(type: String) {
        physicsWorld.contactDelegate = self
        //Load Sound Effects
        sfxController = SFXController(from: self)
        sfxController.preloadSounds()
        sfxController.stopSound(named: "footsteps")
        //Setup Map w/ Graph
        mazeGraph = makeMaze()
        tileManager = TileManager(from: mazeGraph!, with: textureSet)
        tileManager.addTilesTo(scene: self)
        //Initialize all characters, including player, opponent, and monsters
        //Spawn Game Elements
        characterInitialization(type)
        spawnMinimap(graph: mazeGraph!)
        spawnJoystick()
        player1.spawnCamera()
        trophySystemSetup()
        //Optimization
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
        //Spawn HUD
        spawnInfo()
        spawnPause()
        textureInitialization()
        initializeHudPositions()
        moveMinimap(toTheRight: !data.bool(forKey: "minimapPos"))
        moveJoystick(toTheRight: data.bool(forKey: "joystickPos"))
        startUpdateFlag = true
    }
    
    func generateOpponent() {
        
    }
    
    func playerToTrophyResponse() {
        //Increment Score
        player1.incrementScore()
        info.changePlayerScore(newScore: player1.player_Score)
        //Spawn New Trophy and appropriate response
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)
        opponent.stop()
        opponent.gridPos = tileManager.indexFrom(position: opponent.position)
        if let ai = opponent as? AI {
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            ai.moveShortestPath(to: trophyGridPos)
        }
        sfxController.playSound(named: "trophy-collect")
        player1CollisionFlag = false
    }
    
    func opponentToTrophyResponse() {
        //Increment Score
        opponent.incrementScore()
        info.changeAIScore(newScore: opponent.score)
        //Spawn New Trophy and appropriate response
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)
        opponent.stop()
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.gridPos = tileManager.indexFrom(position: opponent.position)
        if let ai = opponent as? AI {
            ai.moveShortestPath(to: trophyGridPos)
        }
        sfxController.playSound(named: "trophy-collect")
        opponentCollisionFlag = false
    }
    
    func checkMonsterWin() {
        //Check loss
        info.endGame()
        sfxController.playSound(named: "game-over")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.info.playerDiedDisplay(xCoord: self.player1.position.x, yCoord: self.player1.position.y)
        }
    }
    
    func makeMaze() -> GKGridGraph<GKGridGraphNode> {
        //Generate Maze
        let maze = Maze(width: Maze.MAX_COLUMNS, height: Maze.MAX_ROWS)
        let graph = maze.graph
        
        return graph
    }
    
}
