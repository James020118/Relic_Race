//
//  GraphNodeEquality.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-17.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import GameplayKit

extension GKGridGraphNode {
    func equals(to node: GKGridGraphNode) -> Bool {
        return gridPosition == node.gridPosition
    }
}
