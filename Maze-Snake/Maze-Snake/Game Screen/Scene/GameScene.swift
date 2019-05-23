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
let velocityMultiplier: CGFloat = 0.2
//Contact Identifiers
let playerCategory: UInt32 = 0x1 << 1
let trophyCategory: UInt32 = 0x1 << 2
let monsterCategory: UInt32 = 0x1 << 3

/*-----------------
 Scene for PvAI Gameplay
 -----------------*/
class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK:- Gameplay Properties
    
    //Graph for Maze
    var mazeGraph: GKGridGraph<GKGridGraphNode>?
    //Manages grid-like tiles
    var tileManager: TileManager!
    //Joystick to control player
    var joystick = AnalogJoystick(diameter: 150)
    //Determine whether joystick is on the left side or right side of the screen
    var joystick_On_The_Right = true
    
    //Actors
    var player1: Player!
    var opponent: AI!
    
    //Monsters
    var monsters = [Monster]()
    
    //Objective
    var trophy: Trophy!
    
    //Real-time Tracking Minimap
    var minimap: MiniMapNode!
    var minimap_On_The_Left = true
    
    //Display various information
    var info: InfoDisplay!
    var DISPLAY_OFFSET_X: CGFloat = 625
    var DISPLAY_OFFSET_Y: CGFloat = 375
    
    var LABEL_OFFSET_X: CGFloat = 625
    var LABEL_OFFSET_Y: CGFloat = 375
    var pause = SKSpriteNode()
    
    //Walking textures
    var walking_Down_TextureAtlas = SKTextureAtlas()
    var walking_Down_Textures = [SKTexture]()
    
    //Textures for maze
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "floor_texture"),
        wall: SKTexture(imageNamed: "wall_texture")
    )
    
    //Parent VC instance
    var parentVC: GameViewController!
    
    //Time Since Last Update(:) call
    private var lastUpdateTime : TimeInterval = 0
    
    //MARK:- Lifecycle Functions
    /* Function that is called when scene loads */
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        super.sceneDidLoad()
        
        let maze = Maze(width: Maze.MAX_COLUMNS, height: Maze.MAX_ROWS)
        mazeGraph = maze.graph
        let graph = mazeGraph ?? blankGraph()
        tileManager = TileManager(from: graph, with: textureSet)
        tileManager.addTilesTo(scene: self)
        
        self.lastUpdateTime = 0
        
        //Initialize all characters, including player, opponent, and monsters
        characterInitialization()
        
        spawnMinimap(graph: graph)
        spawnJoystick()
        player1.spawnCamera()
        
        trophy = Trophy(texture: SKTexture(image: #imageLiteral(resourceName: "Trophyy.png")), scene: self)
        minimap.updateTrophy(position: trophy.position)
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.moveShortestPath(to: trophyGridPos)
        
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
        
        info = InfoDisplay(parent: self)
        info.displayHealth(xCoord: player1.position.x + DISPLAY_OFFSET_X, yCoord: player1.position.y + DISPLAY_OFFSET_Y)
        info.displayPlayerScore(xCoord: player1.position.x - LABEL_OFFSET_X, yCoord: player1.position.y - LABEL_OFFSET_Y, score: player1.player_Score)
        info.displayAIScore(xCoord: player1.position.x - LABEL_OFFSET_X, yCoord: player1.position.y - LABEL_OFFSET_Y - 50, score: opponent.AI_Score)
        
        pause = SKSpriteNode(imageNamed: "pause")
        pause.zPosition = 2
        pause.size = CGSize(width: 200, height: 200)
        pause.position = CGPoint(x: player1.position.x, y: player1.position.y + DISPLAY_OFFSET_Y + 35)
        pause.name = "pause"
        addChild(pause)
        
        textureInitialization()
        player1.run(SKAction.repeatForever(SKAction.animate(with: walking_Down_Textures, timePerFrame: 0.25)))
    }
    
    var isPausing = false
    /* Function that is called when user touches screen */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
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
    
    
    /* Function that is called before each frame is rendered */
    var lastOppUpdate: TimeInterval = 0
    var lastCheck: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        
        
        if player1CollisionFlag {
            player1.incrementScore()
            info.changePlayerScore(newScore: player1.player_Score)
            
            trophy.setRandomPosition()
            minimap.updateTrophy(position: trophy.position)
            opponent.stop()
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            opponent.gridPos = tileManager.indexFrom(position: opponent.position)
            opponent.moveShortestPath(to: trophyGridPos)
            player1CollisionFlag = false
        }
        
        if opponentCollisionFlag {
            opponent.incrementScore()
            info.changeAIScore(newScore: opponent.AI_Score)
            
            trophy.setRandomPosition()
            minimap.updateTrophy(position: trophy.position)
            opponent.stop()
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            opponent.gridPos = tileManager.indexFrom(position: opponent.position)
            opponent.moveShortestPath(to: trophyGridPos)
            opponentCollisionFlag = false
        }
        
        if monsterCollisionFlag != -1 {
            player1.decreaseHealth()
            info.changeHealth(healthPoint: player1.player_Health)
            
            hittingMonster()
            tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
            monsterCollisionFlag = -1
            
            if player1.player_Health == 0 {
                info.endGame()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.info.playerDiedDisplay(xCoord: self.player1.position.x, yCoord: self.player1.position.y)
                }
            }
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime
        
        
        let dOppT = currentTime - lastOppUpdate
        if dOppT > 0.125 {
            minimap.updateOpponent(position: opponent.position)
            var points = [CGPoint]()
            for monster in monsters {
                points.append(monster.position)
            }
            minimap.updateMonsters(positions: points)
            self.lastOppUpdate = currentTime
        }
        
        let dCheckT = currentTime - lastCheck
        if dCheckT > 0.5 {
            if player1.player_Score == 5 {
                info.endGame()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.info.roundWinDisplay(winner: "player", xCoord: self.player1.position.x, yCoord: self.player1.position.y)
                }
            } else if opponent.AI_Score == 5 {
                info.endGame()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.info.roundWinDisplay(winner: "ai", xCoord: self.player1.position.x, yCoord: self.player1.position.y)
                }
            }
            self.lastCheck = currentTime
        }
        
        self.lastUpdateTime = currentTime
    }
    
    //MARK:- Game Element Inits
    /* Game Element Initialization of Properties  */
    
    //Joystick Init
    var JOYSTICK_X_OFFSET : CGFloat = 600
    var JOYSTICK_Y_OFFSET : CGFloat = 275
    func spawnJoystick() {
        // initialize joystick
        joystick.stick.image = #imageLiteral(resourceName: "stick.png")
        joystick.substrate.image = #imageLiteral(resourceName: "substrate.png")
        joystick.substrate.diameter += 175
        joystick.stick.diameter += 105
        joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        joystick.zPosition = 1
        addChild(joystick)
        
        joystick.trackingHandler = { [unowned self] data in
            // track positions
            self.player1.position = CGPoint(x: self.player1.position.x + (data.velocity.x * velocityMultiplier), y: self.player1.position.y + (data.velocity.y * velocityMultiplier))
            self.player1.updateZoom()
            self.joystick.position = CGPoint(x: self.player1.position.x + self.JOYSTICK_X_OFFSET, y: self.player1.position.y - self.JOYSTICK_Y_OFFSET)
            self.minimap.position = CGPoint(x: self.player1.position.x - self.MINIMAP_OFFSET_X, y: self.player1.position.y + self.MINIMAP_OFFSET_Y)
            self.minimap.updatePlayer(position: self.player1.position)
            self.info.updateHealthPos(newX: self.player1.position.x + self.DISPLAY_OFFSET_X, newY: self.player1.position.y + self.DISPLAY_OFFSET_Y)
            self.info.updateScoreLabelPos(newX: self.player1.position.x - self.DISPLAY_OFFSET_X, newY: self.player1.position.y - self.DISPLAY_OFFSET_Y)
            self.pause.position = CGPoint(x: self.player1.position.x, y: self.player1.position.y + self.DISPLAY_OFFSET_Y + 35)
            self.info.playerScoreLabel.position = CGPoint(x: self.player1.position.x - self.LABEL_OFFSET_X, y: self.player1.position.y - self.LABEL_OFFSET_Y)
            self.info.AIScoreLabel.position = CGPoint(x: self.player1.position.x - self.LABEL_OFFSET_X, y: self.player1.position.y - self.LABEL_OFFSET_Y - 50)
           //Optimization
            self.tileManager.viewOnScreenTiles(pos: self.player1.position, parent: self)
        }
        
    }
    
    //Minimap init
    var MINIMAP_OFFSET_X : CGFloat = 600
    var MINIMAP_OFFSET_Y : CGFloat = 325
    func spawnMinimap(graph: GKGridGraph<GKGridGraphNode>) {
        minimap = MiniMapNode(maze: graph, self)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
    }
    
    //MARK:- SKPhysicsContactDelegate
    
    /* Function called when 2 physics bodies collide */
    //Flags to detect when there is a meaningful collsion
    var player1CollisionFlag = false
    var opponentCollisionFlag = false
    var monsterCollisionFlag = -1
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node ?? SKNode()
        let contactB = contact.bodyB.node ?? SKNode()

        if (contactA.name == "trophy") || (contactB.name == "trophy") {
            //Trophy-Player
            if (contactA.name == "player1") || (contactB.name == "player1") {
                player1CollisionFlag = true
            //Trophy-AI
            }else if contactA.name == "ai" || contactB.name == "ai" {
                opponentCollisionFlag = true
            }
            return
        }
        for i in 0..<monsters.count {
            if (contactA.name == monsters[i].name) || (contactB.name == monsters[i].name) {
                //Monster-Player
                if (contactA.name == "player1") || (contactB.name == "player1") {
                    monsterCollisionFlag = i
                }
            }
        }
    }
}
