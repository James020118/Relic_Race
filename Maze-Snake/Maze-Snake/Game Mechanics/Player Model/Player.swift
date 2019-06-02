//
//  Player.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-08.
//  Copyright © 2019 YBMW. All rights reserved.
//
import Foundation
import SpriteKit

class Player: Actor {
    
    var player_Score = 0
    var player_Health = 3
    
    var camera: SKCameraNode
    
    init(texture: SKTexture?, parent: GameScene) {
        camera = SKCameraNode()
        super.init(texture: texture, parent: parent, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-2))
        spawnPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        camera = SKCameraNode()
        super.init(coder: aDecoder)
    }
    
    func updateZoom() {
        camera.position = position
    }
    
    private func spawnPlayer() {
        guard let scene = parent as? GameScene else {
            return
        }
        
        zPosition = 1
        // Player spawn point: Top left corner of the maze
        position = scene.tileManager.tiles[Maze.MAX_ROWS-2][1].position
        
        // create physics body for the player
        physicsBody = SKPhysicsBody(circleOfRadius: frame.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0
        physicsBody?.categoryBitMask = playerCategory
        physicsBody?.contactTestBitMask = trophyCategory
        physicsBody?.collisionBitMask = trophyCategory
    }
    
    
    let cameraScaleConstant: CGFloat = 0.4
    func spawnCamera() {
        guard let scene = parent as? GameScene else {
            return
        }
        scene.addChild(camera)
        scene.camera = camera
        camera.position = position
        // camera zoom
        camera.xScale = cameraScaleConstant
        camera.yScale = cameraScaleConstant
    }
    
    func animateWalk(in direction: Direction) {
        guard let scene = parent as? GameScene else {
            return
        }
        
        stop()
        scene.sfxController.stopSound(named: "footsteps")
        
        var atlas = [SKTexture]()
        switch direction {
        case .up:
            atlas = scene.walking_Up_Textures
        case .down:
            atlas = scene.walking_Down_Textures
        case .right:
            atlas = scene.walking_Right_Textures
        case .left:
            atlas = scene.walking_Left_Textures
        case .none:
            atlas = []
        }
        if !atlas.isEmpty {
            run(SKAction.repeatForever(SKAction.animate(with: atlas, timePerFrame: 0.15)))
            if music_Is_On {
                scene.sfxController.playSound(named: "footsteps", at: 0.6)
            }
        }else {
            texture = SKTexture(imageNamed: "oldMan")
        }
    }
    
    func incrementScore() {
        player_Score += 1
    }
    
    func decreaseHealth() {
        if player_Health > 0 {
            player_Health -= 1
        }
    }
    
}
