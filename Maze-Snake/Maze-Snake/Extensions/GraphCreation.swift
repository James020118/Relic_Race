//
//  BlankGraph.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-06.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import GameplayKit

func blankGraph() -> GKGridGraph<GKGridGraphNode> {
    var Multiarray = [[GKGridGraphNode]]()
    for i in 0..<Maze.MAX_COLUMNS {
        var subArray = [GKGridGraphNode]()
        for j in 0..<Maze.MAX_ROWS {
            subArray.append(GKGridGraphNode(gridPosition: simd_int2(x: Int32(i), y: Int32(j))))
        }
        Multiarray.append(subArray)
    }
    var array = [GKGridGraphNode]()
    for i in 0..<Maze.MAX_COLUMNS {
        for j in 0..<Maze.MAX_ROWS {
            array.append(Multiarray[i][j])
        }
    }
    let graph: GKGridGraph<GKGridGraphNode> = GKGridGraph(array)
    
    return graph
}
