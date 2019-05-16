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
    
    //Objective
    var trophy: Trophy!
    
    //Real-time Tracking Minimap
    var minimap: MiniMapNode!
    
    //Textures for maze
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "Grass_Grid_Center"),
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
        
        player1 = Player(texture: SKTexture(imageNamed: "stick"), parent: self)
        player1.name = "player1"
        opponent = AI(texture: SKTexture(imageNamed: "Water_Grid_Center"), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
        spawnMinimap(graph: graph)
        spawnJoystick()
        player1.spawnCamera()
        
        trophy = Trophy(texture: SKTexture(imageNamed: "trophy"), scene: self)
        minimap.updateTrophy(position: trophy.position)
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.moveShortestPath(to: trophyGridPos)
        
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
    }
    
    
    /* Function that is called when user touches screen */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard let touch = touches.first else { return }
        //let location = touch.location(in: self)
    }
    
    
    /* Function that is called before each frame is rendered */
    var lastOppUpdate: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        
        if player1CollisionFlag {
            trophy.setRandomPosition()
            minimap.updateTrophy(position: trophy.position)
            opponent.stop()
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            opponent.gridPos = tileManager.indexFrom(position: opponent.position)
            opponent.moveShortestPath(to: trophyGridPos)
            player1CollisionFlag = false
        }
        
        if opponentCollisionFlag {
            trophy.setRandomPosition()
            minimap.updateTrophy(position: trophy.position)
            opponent.stop()
            let trophyGridPos = tileManager.indexFrom(position: trophy.position)
            opponent.gridPos = tileManager.indexFrom(position: opponent.position)
            opponent.moveShortestPath(to: trophyGridPos)
            opponentCollisionFlag = false
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
            self.lastOppUpdate = currentTime
        }
        
        self.lastUpdateTime = currentTime
    }
    
    //MARK:- Game Element Inits
    /* Game Element Initialization of Properties  */
    
    //Joystick Init
    let JOYSTICK_X_OFFSET : CGFloat = 450
    let JOYSTICK_Y_OFFSET : CGFloat = 200
    func spawnJoystick() {
        // initialize joystick
        joystick.stick.image = UIImage(named: "stick")
        joystick.substrate.image = UIImage(named: "substrate")
        joystick.substrate.diameter += 105
        joystick.stick.diameter += 65
        joystick.position = CGPoint(x: player1.position.x - JOYSTICK_X_OFFSET, y: player1.position.y - JOYSTICK_Y_OFFSET)
        joystick.zPosition = 1
        addChild(joystick)
        
        joystick.trackingHandler = { [unowned self] data in
            // track positions
            self.player1.position = CGPoint(x: self.player1.position.x + (data.velocity.x * velocityMultiplier), y: self.player1.position.y + (data.velocity.y * velocityMultiplier))
            self.player1.updateZoom()
            self.joystick.position = CGPoint(x: self.player1.position.x - self.JOYSTICK_X_OFFSET, y: self.player1.position.y - self.JOYSTICK_Y_OFFSET)
            self.minimap.position = CGPoint(x: self.player1.position.x + self.MINIMAP_OFFSET_X, y: self.player1.position.y + self.MINIMAP_OFFSET_Y)
            self.minimap.updatePlayer(position: self.player1.position)
           //Optimization
            self.tileManager.viewOnScreenTiles(pos: self.player1.position, parent: self)
        }
        
    }
    
    //Minimap init
    let MINIMAP_OFFSET_X : CGFloat = 600
    let MINIMAP_OFFSET_Y : CGFloat = 325
    func spawnMinimap(graph: GKGridGraph<GKGridGraphNode>) {
        minimap = MiniMapNode(maze: graph, self)
        minimap.position = CGPoint(x: player1.position.x + MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
    }
    
    //MARK:- SKPhysicsContactDelegate
    
    /* Function called when 2 physics bodies collide */
    //Flags to detect when there is a meaningful collsion
    var player1CollisionFlag = false
    var opponentCollisionFlag = false
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
        }
    }
    
}
