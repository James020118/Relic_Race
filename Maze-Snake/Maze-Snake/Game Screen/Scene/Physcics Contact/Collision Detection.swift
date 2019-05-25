//
//  Collision Detection.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-25.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

/* Portion that handles all collisions */
extension GameScene {
    
    /* PLAYER - TROPHY RESPONSE:
     - Increment Player Score
     - Spawn New Trophy
     - Check Win
     */
    func playerCollisionResponse() {
        //Increment Score
        player1.incrementScore()
        info.changePlayerScore(newScore: player1.player_Score)
        //Spawn New Trophy and appropriate response
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)
        opponent.stop()
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.gridPos = tileManager.indexFrom(position: opponent.position)
        opponent.moveShortestPath(to: trophyGridPos)
        player1CollisionFlag = false
        //Check Win
        if player1.player_Score == 5 {
            info.endGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.info.roundWinDisplay(winner: "player", xCoord: self.player1.position.x, yCoord: self.player1.position.y)
            }
        }
    }
    
    /* PLAYER - MONSTER RESPONSE:
     - Take away player life
     - End game if no lives left
     - Respawn
     */
    func monsterCollisionResponse() {
        //Decrement Lives
        player1.decreaseHealth()
        info.changeHealth(healthPoint: player1.player_Health)
        //Respawn
        hittingMonster()
        tileManager.viewOnScreenTiles(pos: player1.position, parent: self)
        monsterCollisionFlag = -1
        //Check loss
        if player1.player_Health == 0 {
            info.endGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.info.playerDiedDisplay(xCoord: self.player1.position.x, yCoord: self.player1.position.y)
            }
        }
    }
    
    /* AI - TROPHY RESPONSE:
        - Increment AI Score
        - Spawn New Trophy
     */
    func opponentCollisionResponse() {
        //Increment Score
        opponent.incrementScore()
        info.changeAIScore(newScore: opponent.AI_Score)
        //Spawn New Trophy and appropriate response
        trophy.setRandomPosition()
        minimap.updateTrophy(position: trophy.position)
        opponent.stop()
        let trophyGridPos = tileManager.indexFrom(position: trophy.position)
        opponent.gridPos = tileManager.indexFrom(position: opponent.position)
        opponent.moveShortestPath(to: trophyGridPos)
        opponentCollisionFlag = false
        //Check Win
        if opponent.AI_Score == 5 {
            info.endGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.info.roundWinDisplay(winner: "ai", xCoord: self.player1.position.x, yCoord: self.player1.position.y)
            }
        }
    }
    
    
    
    //MARK:- SKPhysicsContactDelegate
    /* Function called when 2 physics bodies collide */
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.node ?? SKNode()
        let contactB = contact.bodyB.node ?? SKNode()
        
        //Check Meaningless Collisions first to improve performance
        if (contactA.name == "wall") || (contactB.name == "wall") {
            return
        }
        
        /* Collisions involving the trophy */
        if (contactA.name == "trophy") || (contactB.name == "trophy") {
            //Trophy-Player
            if (contactA.name == "player1") || (contactB.name == "player1") {
                player1CollisionFlag = true
                //Trophy-AI
            }else if contactA.name == "ai" || contactB.name == "ai" {
                opponentCollisionFlag = true
            }
            return
        }
        /* Collisions involving the trophy */
        //Check all monsters
        for i in 0..<monsters.count {
            if (contactA.name == monsters[i].name) || (contactB.name == monsters[i].name) {
                //Monster-Player
                if (contactA.name == "player1") || (contactB.name == "player1") {
                    //Flag is position of monster
                    monsterCollisionFlag = i
                }
            }
        }
    }
    
    
}
