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
    
    static let MAX_ROWS = 24
    static let MAX_COLUMNS = 32
    static let KEY = "gamma"
    
    init() {
        //TODO: Add Gamma Maze Generation
        //TODO: Find way to store maze
    }
    
    //TODO: Generate Graph from Maze
    var graph: GKGridGraph<GKGridGraphNode> {
        return GKGridGraph()
    }
    
}
