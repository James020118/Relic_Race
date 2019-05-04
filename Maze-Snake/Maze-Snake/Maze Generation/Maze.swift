//
//  Mazze.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-04.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Maze {
    
    static let MAX_ROWS = 32
    static let MAX_COLUMNS = 24
    
    init() {
        //TODO: Add Gamma Maze Generation
        //TODO: Find way to store maze
    }
    
    var graph: GKGridGraph<GKGridGraphNode> {
        return GKGridGraph()
    }
    
}
