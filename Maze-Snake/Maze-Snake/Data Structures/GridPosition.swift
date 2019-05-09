//
//  GridPosition.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-08.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

struct GridPosition {
    var column: Int
    var row: Int
    
    init(from vector: vector_int2) {
        column = Int(vector.x)
        row = Int(vector.y)
    }
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
}
