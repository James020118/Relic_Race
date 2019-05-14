//
//  GameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import SpriteKit
import GameplayKit

let velocityMultiplier: CGFloat = 0.3

let playerCategory: UInt32 = 0x1 << 1
let trophyCategory: UInt32 = 0x1 << 2

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mazeGraph: GKGridGraph<GKGridGraphNode>?
    
    var tileManager: TileManager!
    
    var joystick = AnalogJoystick(diameter: 150)
    var player1: Player!
    
    var trophy: Trophy!
    
    var minimap: MiniMapNode!
    
    let textureSet = TextureSet(
        floor: SKTexture(imageNamed: "Grass_Grid_Center"),
        wall: SKTexture(imageNamed: "wall_repeat-Two")
    )
    
    private var lastUpdateTime : TimeInterval = 0
    
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
        spawnMinimap(graph: graph)
        spawnJoystick()
        player1.spawnCamera()
        
        trophy = Trophy(texture: SKTexture(imageNamed: "trophy"), scene: self)
//        trophy.physicsBody = SKPhysicsBody(circleOfRadius: 50)
//        trophy.physicsBody?.isDynamic = false
        trophy.name = "trophy"
        minimap.updateTrophy(position: trophy.position)
        
//        player1.physicsBody?.categoryBitMask = playerCategory
//        player1.physicsBody?.contactTestBitMask = trophyCategory
//        player1.physicsBody?.collisionBitMask = trophyCategory
//
//        trophy.physicsBody?.categoryBitMask = trophyCategory
//        trophy.physicsBody?.contactTestBitMask = playerCategory
//        trophy.physicsBody?.collisionBitMask = playerCategory
        
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard let touch = touches.first else { return }
        //let location = touch.location(in: self)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if player1.position.x > trophy.position.x - 50 && player1.position.x < trophy.position.x + 50 && player1.position.y > trophy.position.y - 50 && player1.position.y < trophy.position.y + 50 {
                trophy.setRandomPosition()
                minimap.updateTrophy(position: trophy.position)
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
    }
    
    
    
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
           self.tileManager.viewOnScreenTiles(pos: self.player1.position, parent: self)
        }
        
    }
    
    let MINIMAP_OFFSET_X : CGFloat = 600
    let MINIMAP_OFFSET_Y : CGFloat = 325
    func spawnMinimap(graph: GKGridGraph<GKGridGraphNode>) {
        minimap = MiniMapNode(maze: graph, self)
        minimap.position = CGPoint(x: player1.position.x + MINIMAP_OFFSET_X, y: player1.position.y + MINIMAP_OFFSET_Y)
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let contactA = contact.bodyA.node ?? SKNode()
//        let contactB = contact.bodyB.node ?? SKNode()
//
//        if (contactA.name == "trophy") || (contactB.name == "trophy") {
//            if (contactA.name == "player1") || (contactB.name == "player1") {
//                trophy.setRandomPosition()
//                minimap.updateTrophy(position: trophy.position)
//                contact.bodyB.node!.physicsBody = contact.bodyB.node!.physicsBody
//                contact.bodyA.node!.physicsBody = contact.bodyA.node!.physicsBody
//            }
//        }
//    }
    
}
