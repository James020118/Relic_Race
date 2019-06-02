//
//  ScoringPacket.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-06-01.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation

struct ScoringPacket : Codable {
    let score: Int
    let pos: GridPosition
}
