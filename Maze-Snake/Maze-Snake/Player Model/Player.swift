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
    
    override init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        camera = SKCameraNode()
        super.init(texture: texture, parent: parent, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        camera = SKCameraNode()
        super.init(coder: aDecoder)
    }
    
    override func movePosition(to direction: Direction) {
        super.movePosition(to: direction)
        followZoom()
    }
    
    private func followZoom() {
        camera.position = position
    }
    
}
