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
    
    //Actors
    var player1: Player!
    var opponent: AI!
    
    //Monsters
    var monster1: Monster!
    var monster2: Monster!
    
    //Objective
    var trophy: Trophy!
    
    //Real-time Tracking Minimap
    var minimap: MiniMapNode!
    
    //Display various information
    var info: InfoDisplay!
    
    //Textures for maze
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "floor1"),
        wall: SKTexture(imageNamed: "wall_repeat-Two")
    )
    
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
        
        monster1 = Monster(texture: SKTexture(imageNamed: "monster"), parent: self)
        monster1.name = "monster1"
        monster2 = Monster(texture: SKTexture(imageNamed: "monster"), parent: self)
        monster2.name = "monster2"
        
        player1 = Player(texture: SKTexture(imageNamed: "player"), parent: self)
        player1.name = "player1"
        opponent = AI(texture: SKTexture(imageNamed: "monster"), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
        spawnMinimap(graph: graph)
        spawnJoystick()
        player1.spawnCamera()
        
        trophy = Trophy(texture: SKTexture(imageNamed: "Trophyy"), scene: self)
        minimap.updateTrophy(position: trophy.position)
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.moveShortestPath(to: trophyGridPos)
        
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
        
        info = InfoDisplay(parent: self)
        info.displayHealth(xCoord: player1.position.x + 625, yCoord: player1.position.y + 375)
        info.displayPlayerScore(xCoord: player1.position.x, yCoord: player1.position.y + 425, score: player1.player_Score)
        info.displayAIScore(xCoord: player1.position.x, yCoord: player1.position.y + 375, score: opponent.AI_Score)
    }
    
    
    /* Function that is called when user touches screen */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        joystick.position = location
//        JOYSTICK_X_OFFSET = location.x - player1.position.x
//        JOYSTICK_Y_OFFSET = location.y - player1.position.y
    }
    
    
    /* Function that is called before each frame is rendered */
    var lastOppUpdate: TimeInterval = 0
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
        
        if monsterCollisionFlag {
            player1.decreaseHealth()
            info.changeHealth(healthPoint: player1.player_Health)
            
            resetGame()
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            opponent.gridPos = tileManager.indexFrom(position: opponent.position)
            opponent.moveShortestPath(to: trophyGridPos)
            monsterCollisionFlag = false
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
            minimap.updateMonster(position: monster1.position)
            minimap.updateMonster2(position: monster2.position)
            self.lastOppUpdate = currentTime
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
        joystick.stick.image = UIImage(named: "stick")
        joystick.substrate.image = UIImage(named: "substrate")
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
            self.info.updateHealthPos(newX: self.player1.position.x + 625, newY: self.player1.position.y + 375)
            self.info.updateScoreLabelPos(newX: self.player1.position.x, newY: self.player1.position.y + 425)
           //Optimization
            self.tileManager.viewOnScreenTiles(pos: self.player1.position, parent: self)
        }
        
    }
    
    //Minimap init
    let MINIMAP_OFFSET_X : CGFloat = 600
    let MINIMAP_OFFSET_Y : CGFloat = 325
    func spawnMinimap(graph: GKGridGraph<GKGridGraphNode>) {
        minimap = MiniMapNode(maze: graph, self)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
    }
    
    //MARK:- SKPhysicsContactDelegate
    
    /* Function called when 2 physics bodies collide */
    //Flags to detect when there is a meaningful collsion
    var player1CollisionFlag = false
    var opponentCollisionFlag = false
    var monsterCollisionFlag = false
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
        } else if (contactA.name == "monster1") || (contactB.name == "monster1") || (contactA.name == "monster2") || (contactB.name == "monster2") {
            //Monster-Player
            if (contactA.name == "player1") || (contactB.name == "player1") {
                monsterCollisionFlag = true
            }
        }
    }
    
    func resetGame() {
        player1.position = tileManager.tiles[Maze.MAX_ROWS-2][1].position
        player1.player_Score = 0
        player1.updateZoom()
        info.changePlayerScore(newScore: player1.player_Score)
        
        opponent.stop()
        opponent.position = tileManager.tiles[1][Maze.MAX_COLUMNS-2].position
        opponent.gridPos = GridPosition(column: Maze.MAX_COLUMNS-2, row: 1)
        opponent.AI_Score = 0
        info.changeAIScore(newScore: opponent.AI_Score)
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)

        joystick.position = CGPoint(x: player1.position.x + JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        minimap.position = CGPoint(x: player1.position.x - MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
    }
    
}
