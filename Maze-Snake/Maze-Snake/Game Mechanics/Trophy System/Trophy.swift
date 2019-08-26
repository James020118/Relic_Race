//
//  Trophy.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-13.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Trophy: SKSpriteNode {
    
    weak var gameScene: GameScene?
    
    init(texture: SKTexture, scene: GameScene) {
        gameScene = scene
        let width: CGFloat = gameScene!.size.width / CGFloat(Maze.MAX_COLUMNS)
        let height: CGFloat = gameScene!.size.height / CGFloat(Maze.MAX_ROWS)
        let size = CGSize(width: width, height: height)
        super.init(texture: texture, color: .blue, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: 50)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = trophyCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = playerCategory
        name = "trophy"
        spawn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        gameScene = GameScene(size: CGSize(width: 0, height: 0))
        super.init(coder: aDecoder)
    }
    
    func spawn() {
        gameScene!.addChild(self)
        zPosition = 6
        setRandomPosition()
    }
    
    /* Function that controls where the trophies are placed in-game */
    func setRandomPosition() {
       MSTBasedFairPosition()
    }
    
    
    //MARK:- Minimum Spanning Tree
    /* Set trophy random position
     Use breath-first search twice to make a shortest path mapping of every vertex from both players
     Compare the 2 maps to find tiles that are:
        1. Atleast 36 tiles away from each player
        2. Have a similiar length: ± 7
     */
    func MSTBasedFairPosition() {
        //Get Player Pos
        let playerPosGrid = gameScene!.tileManager!.indexFrom(position: gameScene!.player1!.position)
        //Convert 2-D mapping to 1-D
        let playerPos = playerPosGrid.row*Maze.MAX_COLUMNS + playerPosGrid.column
        //Get map of all distances
        let mappedDist1 = distances(from: playerPos, using: gameScene!.mazeGraph!)
        
        //Repeat for opponent
        let oppPosGrid = gameScene!.tileManager!.indexFrom(position: gameScene!.opponent!.position)
        let oppPos = oppPosGrid.row*Maze.MAX_COLUMNS + oppPosGrid.column
        let mappedDist2 = distances(from: oppPos, using: gameScene!.mazeGraph!)
        
        var viableTile = [GridPosition]()
        //Compare each mapping to find ideal tile for trophy placement
        for y in 0..<mappedDist1.count {
            for x in 0..<mappedDist1[y].count {
                let MIN_LENGTH_OT = mappedDist2[y][x] > 36
                let MIN_LENGTH_PT = mappedDist1[y][x] > 36
                let SIMILIAR_LENTH =  mappedDist2[y][x] + 7 >= mappedDist1[y][x] && mappedDist2[y][x] - 7 <= mappedDist1[y][x]
                
                if MIN_LENGTH_OT && MIN_LENGTH_PT && SIMILIAR_LENTH {
                    viableTile.append(GridPosition(column: x, row: y))
                }
            }
        }
        if viableTile.isEmpty {
            CircleBasedRandomPositioning()
            return
        }
        
        let randPos = viableTile.randomElement()!
        let tile = gameScene!.tileManager!.getTile(row: randPos.row, column: randPos.column)
        position = tile.position
        
    }
    /*
     Patrick's alogrithm that uses a breath-first search to efficiently ( O(|E| + |V|) ) to create a minimum spanning tree (or in other words, a mapping showing distances to every node from a source node)
     */
    func distances(from src: Int, using graph: GKGridGraph<GKGridGraphNode>) -> [[Int]] {
        //Creating Queue
        var queue = Queue<GKGridGraphNode>()
        let srcNode = graph.nodes![src] as! GKGridGraphNode
        let srcPos = GridPosition(from: srcNode.gridPosition)
        queue.enqueue(srcNode)

        //Visited Array for Breath-first search
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: Maze.MAX_COLUMNS), count: Maze.MAX_ROWS)
        visited[srcPos.row][srcPos.column] = true
        
        //Array to track final distances
        var dist = [[Int]](repeating: [Int](repeating: -1, count: Maze.MAX_COLUMNS), count: Maze.MAX_ROWS)
        dist[srcPos.row][srcPos.column] = 0
        
        //Search
        while let rootNode = queue.dequeue() {
            for neighbour in rootNode.connectedNodes {
                let neighbourNode = neighbour as! GKGridGraphNode
                let neighbourPos = GridPosition(from: neighbourNode.gridPosition)
                if !visited[neighbourPos.row][neighbourPos.column] {
                    queue.enqueue(neighbourNode)
                    let rootPos = GridPosition(from: rootNode.gridPosition)
                    dist[neighbourPos.row][neighbourPos.column] = dist[rootPos.row][rootPos.column] + 1
                    visited[neighbourPos.row][neighbourPos.column] = true
                }
            }
        }
        
        return dist
    }
    
    
    
    //MARK:- Ximings's Position-based Algo
    /* Set trophy random position
     calculate the distance between the trophy and the player
     and the distance between the trophy and the ai
     then choose floor tiles that
     1. have similar distance to both player and the ai
     2. have a distance greater than 8 times the width and height of the tile
     */
    func XimingsRandomTrophyPositioning() {
        let tile = gameScene!.tileManager!.getRandomTile(condition: { tile in
            let dx1 = abs(tile.position.x - gameScene!.player1.position.x)
            let dx2 = abs(tile.position.x - gameScene!.opponent.position.x)
            let dy1 = abs(tile.position.y - gameScene!.player1.position.y)
            let dy2 = abs(tile.position.y - gameScene!.opponent.position.y)
            return (abs(dx1 - dx2) < tile.frame.width * 7) && (abs(dy1 - dy2) < tile.frame.height * 7) && (dx1 > tile.frame.width * 8) && (dy1 > tile.frame.height * 8)
        })
        position = tile.position
    }
    
    
    //MARK:- Pathfinding-distance fairness
    /* Set trophy random position
     Uses pathfinding to pick a random tile that is:
        1. Atleast 20 tiles away from each player
        2. Have a similiar length: ± 5
     */
    func graphBasedRandomPositioning() {
        let tile = gameScene!.tileManager!.getRandomTile(condition: { tile in
            let opponentPos = gameScene!.tileManager!.indexFrom(position: gameScene!.opponent.position)
            let opponentNode = gameScene!.tileManager!.getTile(row: opponentPos.row, column: opponentPos.column).node
            let shortestPathOT = gameScene!.mazeGraph!.findPath(from: tile.node, to: opponentNode).count
            
            let playerPos = gameScene!.tileManager!.indexFrom(position: gameScene!.player1.position)
            let playerNode = gameScene!.tileManager!.getTile(row: playerPos.row, column: playerPos.column).node
            let shortestPathPT = gameScene!.mazeGraph!.findPath(from: tile.node, to: playerNode).count
            
            let MIN_LENGTH_OT = shortestPathOT > 20
            let MIN_LENGTH_PT = shortestPathPT > 20
            let SIMILIAR_LENTH =  shortestPathOT + 5 >= shortestPathPT && shortestPathOT - 5 <= shortestPathPT
            
            return MIN_LENGTH_OT && MIN_LENGTH_PT && SIMILIAR_LENTH
        })
        
        position = tile.position
    }
    
    
    //MARK:-Circle-based
    /* Set trophy random position
     Draw Circles b/w opponent & player positions.
     Find both POIS and use those points to create a line.
     Choose a random point on that line
     */
    func CircleBasedRandomPositioning() {
        let dx = abs(gameScene!.opponent.position.x - gameScene!.player1.position.x)
        let dy = abs(gameScene!.opponent.position.y - gameScene!.player1.position.y)
        let diameter = dx > dy ? dx : dy
        let circle1 = Circle(
            x: gameScene!.player1.position.x,
            y: gameScene!.player1.position.y,
            r: diameter/2
        )
        let circle2 = Circle(
            x: gameScene!.opponent.position.x,
            y: gameScene!.opponent.position.y,
            r: diameter/2
        )
        
        let solutions = intersectTwoCircles(c1: circle1, c2: circle2)
        
        let sameCircle = circle1.x == circle2.x && circle1.y == circle2.y
        if sameCircle || solutions.isEmpty {
            XimingsRandomTrophyPositioning()
            return
        }
        
        //Make a line that represents the possible possitions to generate random, fair points
        var newPos = CGPoint.zero
        if solutions.count == 1 {
            //Possibilities are a vertical line from solution
            newPos.x = solutions[0].x
            newPos.y = CGFloat.random(in: -gameScene!.frame.height/2..<gameScene!.frame.height/2)
        }else if solutions.count == 2 {
            newPos = point(from: solutions)
        }
        
        let tilePos = gameScene!.tileManager!.indexFrom(position: newPos)
        var tile = gameScene!.tileManager!.getTile(row: tilePos.row, column: tilePos.column)
        
        if tile.typeName == "space" {
            position = tile.position
            return
        }
        
        //If random point landed on is a wall, find nearest space
        //Check around in cardinal directions
        tile = changeToNeighbour(from: tilePos)
        
        if tile.typeName == "wall" {
            XimingsRandomTrophyPositioning()
            return
        }
        
        position = tile.position
    }
    func changeToNeighbour(from tilePos: GridPosition) -> TileNode {
        var tile: TileNode!
        var possibleDirection = [Direction]()
        var flag = true
        if tilePos.column == Maze.MAX_COLUMNS-2 {
            possibleDirection.append(.left)
            flag = false
        }else if tilePos.column == 1 {
            possibleDirection.append(.right)
            flag = false
        }
        if tilePos.row == Maze.MAX_ROWS-2 {
            possibleDirection.append(.up)
            flag = false
        }else if tilePos.row == 1 {
            possibleDirection.append(.down)
            flag = false
        }
        if flag {
            possibleDirection = [.up, .down, .left, .right]
        }
        
        loop: for direction in possibleDirection {
            switch direction {
            case .up:
                let neighbourTile = nearestNeighbour(column: tilePos.column, row: tilePos.row+1)
                if let neighbourTile = neighbourTile {
                    tile = neighbourTile
                    break loop
                }
            case .down:
                let neighbourTile = nearestNeighbour(column: tilePos.column, row: tilePos.row-1)
                if let neighbourTile = neighbourTile {
                    tile = neighbourTile
                    break loop
                }
            case .left:
                let neighbourTile = nearestNeighbour(column: tilePos.column-1, row: tilePos.row)
                if let neighbourTile = neighbourTile {
                    tile = neighbourTile
                    break loop
                }
            case .right:
                let neighbourTile = nearestNeighbour(column: tilePos.column+1, row: tilePos.row)
                if let neighbourTile = neighbourTile {
                    tile = neighbourTile
                    break loop
                }
            case .none:
                print("Bruh")
            }
        }
        
        return tile
    }
    func nearestNeighbour(column: Int, row: Int) -> TileNode? {
        let newTile = gameScene!.tileManager!.getTile(row: row, column: column)
        if newTile.typeName == "space" {
            return newTile
        }
        return nil
    }
    func point(from solutions: [CGPoint]) -> CGPoint {
        var newPos = CGPoint.zero
        
        if solutions[0].x == solutions[1].x {
            //Possibilities are a vertical line from solution
            newPos.x = solutions[0].x
            newPos.y = CGFloat.random(in: -gameScene!.frame.height/2..<gameScene!.frame.height/2)
            return newPos
        }
        
        //y = mx + b
        let m = (solutions[1].y - solutions[0].y) / (solutions[1].x - solutions[0].x)
        let b = solutions[0].y - m * solutions[0].x
        
        //Horizontal Line
        if m.rounded() == 0 {
            newPos.y = solutions[0].y
            newPos.x = CGFloat.random(in: -gameScene!.frame.width/2..<gameScene!.frame.width/2)
            return newPos
        }
        
        //Find x intercepts w/ screen
        let topIntVal = ((gameScene!.frame.height/2 - gameScene!.tileManager!.getTile(row: 0, column: 0).frame.height) - b) / m
        let bottomIntVal = ((-gameScene!.frame.height/2 + gameScene!.tileManager!.getTile(row: 0, column: 0).frame.height) - b) / m
        
        var bottomLimit: CGFloat = 0
        var upperLimit: CGFloat = 0
        let LIMIT_LEFT = -gameScene!.frame.width/2 + gameScene!.tileManager!.getTile(row: 0, column: 0).frame.width
        let LIMIT_RIGHT = gameScene!.frame.width/2 - gameScene!.tileManager!.getTile(row: 0, column: 0).frame.width
        //Define upper & lower limits for random # generation
        if m > 0 {
            bottomLimit = LIMIT_LEFT > bottomIntVal ? LIMIT_LEFT : bottomIntVal
            upperLimit = LIMIT_RIGHT > topIntVal ? topIntVal : LIMIT_RIGHT
        }else if m < 0 {
            bottomLimit = LIMIT_LEFT > topIntVal ? LIMIT_LEFT : topIntVal
            upperLimit = LIMIT_RIGHT > bottomIntVal ? bottomIntVal : LIMIT_RIGHT
        }
        //Exclude points near players
        let closenessRadius: CGFloat = 500.0
        let playerCloseCircle = Circle(
            x: gameScene!.player1!.position.x,
            y: gameScene!.player1!.position.y,
            r: closenessRadius
        )
        let oppCloseCircle = Circle(
            x: gameScene!.opponent!.position.x,
            y: gameScene!.opponent!.position.y,
            r: closenessRadius
        )
        let lineFunction: ((_ x: CGFloat) -> CGFloat) = { x in
            return m*x + b
        }
        //Find intersection b/w line and circle
        let playerIntersections = FindLineCircleIntersections(
            cx: playerCloseCircle.x,
            cy: playerCloseCircle.y,
            radius: playerCloseCircle.r,
            point1: CGPoint(x: LIMIT_LEFT, y: lineFunction(LIMIT_LEFT)),
            point2: CGPoint(x: LIMIT_RIGHT, y: lineFunction(LIMIT_RIGHT))
        )
        //Exclude Range of found points from possibilities
        if playerIntersections.count == 2 {
            
        }
        
        
        //Generate rand points from line
        newPos.x = CGFloat.random(in: bottomLimit..<upperLimit)
        newPos.y = m * newPos.x + b
        
        return newPos
    }
    
}

extension CGFloat {
    func random(in ranges: [Range<CGFloat>]) -> CGFloat {
        var randomFloats = [CGFloat]()
        for range in ranges {
            let rand = CGFloat.random(in: range)
            randomFloats.append(rand)
        }
        
        return randomFloats.randomElement() ?? 0
    }
}
