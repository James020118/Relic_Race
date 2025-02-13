//
//  TextureSet.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-11.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

/*------------
 A class to hold the textures for a given TileManager
 ------------*/

class TextureSet {
    let floor: SKTexture
    let wall: SKTexture
    
    init(floor: SKTexture, wall: SKTexture) {
        self.floor = floor
        self.wall = wall
    }
    
}
