//
//  MazeEncodingBuffer.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation

struct MazeEncodingBuffer: Codable {
    let tiles: [[String]]
}

/*
 if host {
 //Generate Maze
    let maze = Maze()
    var tiles = [String]()
 //Convert to encoded format
    for tile in maze.tiles {
    if til.type == .Wall {
        tiles.append("wall")
    }else if tile.type == .Floor {
        tiles.append("floor")
    }
    }
 
 let encodedData = MazeEncodingBuffer(tiles: tiles)
 //Send over encodedData
 
 }
 */


/*
 
 if !host {
 //Retrieve the maze data
 let mazebuffer = data ? MazeEncodingBuffer
 
 let maze = Maze(from: mazebuffer)
 
 }
 
 */
