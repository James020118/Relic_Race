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
    
    var camera: SKCameraNode
    
    init(texture: SKTexture?, parent: GameScene) {
        camera = SKCameraNode()
        super.init(texture: texture, parent: parent, pos: GridPosition(column: -1, row: -1))
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
        position = scene.tileManager.tiles[Maze.MAX_ROWS-1][1].position
        gridPos = GridPosition(column: 1, row: Maze.MAX_ROWS-1)
        
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
    
}
