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

    func testCirclePOI() {
        /* MARK:- Testing Results against results at: https://planetcalc.com/8098/ */
        
        //TEST # 1
        let c11 = Circle(
            x: 0,
            y: 0,
            r: 5
        )
        let c21 = Circle(
            x: 10,
            y: 0,
            r: 5
        )
        let sols1 = intersectTwoCircles(c1: c11, c2: c21)
        XCTAssert(sols1 == [CGPoint(x: 5.0, y: 0)], "POIs are not accurate")
        
        //TEST # 2
        let c12 = Circle(
            x: 0,
            y: 0,
            r: 5
        )
        let c22 = Circle(
            x: 0,
            y: 5,
            r: 5
        )
        let sols2 = intersectTwoCircles(c1: c12, c2: c22)
        XCTAssert(sols2 == [
            CGPoint(x: 4.330127018922193, y: 2.5),
            CGPoint(x: -4.330127018922193, y: 2.5),
            ],           "POIs are not accurate")
        
        //TEST # 3
        let c13 = Circle(
            x: 0,
            y: 0,
            r: 1
        )
        let c23 = Circle(
            x: 100,
            y: 100,
            r: 1
        )
        let sols3 = intersectTwoCircles(c1: c13, c2: c23)
        XCTAssert(sols3 == [], "POIs are not accurate")
        
        //TEST # 4
        let c14 = Circle(
            x: 10,
            y: 10,
            r: 500
        )
        let c24 = Circle(
            x: 490,
            y: 400,
            r: 500
        )
        let sols4 = intersectTwoCircles(c1: c14, c2: c24)
        print(sols4)
        XCTAssert(sols4 == [], "POIs are not accurate")
    }
    
}
