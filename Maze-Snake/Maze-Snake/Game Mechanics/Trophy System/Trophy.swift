//
//  Trophy.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-13.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

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
        graphBasedRandomPositioning()
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
        let radius = dx > dy ? dx : dy
        let circle1 = Circle(
            x: gameScene!.player1.position.x,
            y: gameScene!.player1.position.y,
            r: radius
        )
        let circle2 = Circle(
            x: gameScene!.opponent.position.x,
            y: gameScene!.opponent.position.y,
            r: radius
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
        let topIntVal = (gameScene!.frame.width/2 - b) / m
        let bottomIntVal = (-gameScene!.frame.width/2 - b) / m
        
        var bottomLimit: CGFloat = 0
        var upperLimit: CGFloat = 0
        let LIMIT_BOTTOM = -gameScene!.frame.width/2 + gameScene!.tileManager!.getTile(row: 0, column: 0).frame.width
        let LIMIT_TOP = gameScene!.frame.width/2 - gameScene!.tileManager!.getTile(row: 0, column: 0).frame.width
        //Define upper & lower limits for random # generation
        if m > 0 {
            bottomLimit = LIMIT_BOTTOM > bottomIntVal ? LIMIT_BOTTOM : bottomIntVal
            upperLimit = LIMIT_TOP > topIntVal ? topIntVal : LIMIT_TOP
        }else if m < 0 {
            bottomLimit = LIMIT_BOTTOM > topIntVal ? LIMIT_BOTTOM : topIntVal
            upperLimit = LIMIT_TOP > bottomIntVal ? bottomIntVal : LIMIT_TOP
        }
        
        newPos.x = CGFloat.random(in: bottomLimit..<upperLimit)
        newPos.y = m * newPos.x + b
        
        return newPos
    }
    
    
    
}
