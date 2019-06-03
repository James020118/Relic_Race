//
//  Maze_SnakeTests.swift
//  Maze-SnakeTests
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import XCTest
@testable import Maze_Snake
import GameplayKit

class Maze_SnakeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTileManager() {
        var Multiarray = [[GKGridGraphNode]]()
        for i in 0...Maze.MAX_COLUMNS {
            var subArray = [GKGridGraphNode]()
            for j in 0...Maze.MAX_ROWS {
                subArray.append(GKGridGraphNode(gridPosition: simd_int2(x: Int32(i), y: Int32(j))))
            }
            Multiarray.append(subArray)
        }
        
        var array = [GKGridGraphNode]()
        for i in 0...Maze.MAX_COLUMNS {
            for j in 0...Maze.MAX_ROWS {
                array.append(Multiarray[i][j])
            }
        }
        
        let graph: GKGridGraph<GKGridGraphNode> = GKGridGraph(array)
    }
    
    //Original Data Size: 5890 bytes
    //Single Character Size: 3172 bytes
    //Bool Size: 4330 bytes
    func testEncodingGame() {
        let maze = Maze(width: Maze.MAX_COLUMNS, height: Maze.MAX_ROWS)
        let buffer = GameEncodingBuffer(from: maze, and: [])
        var data: Data?
        do {
            data = try JSONEncoder().encode(buffer)
            print(data!)
        }catch {}
        
        var maze2: Maze?
        do {
            let buffer = try JSONDecoder().decode(GameEncodingBuffer.self, from: data!)
            print(data!)
            maze2 = Maze(from: buffer)
        }catch {}
        
        var successfulDecode = true
        for i in 0..<maze.graph.nodes!.count {
            if maze.graph.nodes![i].connectedNodes.count != maze2!.graph.nodes![i].connectedNodes.count {
                successfulDecode = false
            }
        }
        
        XCTAssert(successfulDecode, "Decoding was not successful")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
