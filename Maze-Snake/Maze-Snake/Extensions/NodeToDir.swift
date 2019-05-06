//
//  ArraytoGraph.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-06.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum Direction {
    case left, right, up, down
}

extension GKGridGraphNode {
    func nodeDirections() -> [Direction] {
        var attachments = [Direction]()
        
        for graphNode in connectedNodes {
            let curPos = self.gridPosition
            let node = graphNode as? GKGridGraphNode ?? GKGridGraphNode()
            
            if curPos.x == node.gridPosition.x && curPos.y == node.gridPosition.y + 1 {
                attachments.append(.up)
            }else if curPos.x == node.gridPosition.x && curPos.y == node.gridPosition.y - 1 {
                attachments.append(.down)
            }else if curPos.x == node.gridPosition.x + 1 && curPos.y == node.gridPosition.y {
                attachments.append(.right)
            }else if curPos.x == node.gridPosition.x - 1 && curPos.y == node.gridPosition.y {
                attachments.append(.left)
            }
            
        }
        
        return attachments
    }
}
