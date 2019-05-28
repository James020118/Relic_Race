//
//  OtherPlayer.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class OtherPlayer: Opponent {
    
    override init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        super.init(texture: texture, parent: parent, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
