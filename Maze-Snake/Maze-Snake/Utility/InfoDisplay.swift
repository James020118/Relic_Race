//
//  InfoDisplay.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-05-18.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

// a class for displaying various information in the game scene
class InfoDisplay {
    
    // parent scene
    var parent: GameScene!
    
    // node for displaying health
    private var healthPanel = SKSpriteNode()
    
    init(parent: GameScene) {
        self.parent = parent
    }
    
    // constructing node for displaying health
    let heart1 = SKSpriteNode(imageNamed: "heart")
    let heart2 = SKSpriteNode(imageNamed: "heart")
    let heart3 = SKSpriteNode(imageNamed: "heart")
    func displayHealth(xCoord: CGFloat, yCoord: CGFloat) {
        let frame = SKSpriteNode(imageNamed: "frame")
        frame.size = CGSize(width: 400, height: 150)
        frame.position = CGPoint(x: healthPanel.frame.midX, y: healthPanel.frame.midY)
        
        heart1.size = CGSize(width: 100, height: 100)
        heart2.size = CGSize(width: 100, height: 100)
        heart3.size = CGSize(width: 100, height: 100)
        
        heart1.position = CGPoint(x: healthPanel.frame.midX - 100, y: healthPanel.frame.midY)
        heart2.position = CGPoint(x: healthPanel.frame.midX, y: healthPanel.frame.midY)
        heart3.position = CGPoint(x: healthPanel.frame.midX + 100, y: healthPanel.frame.midY)
        
        healthPanel.addChild(frame)
        healthPanel.addChild(heart1)
        healthPanel.addChild(heart2)
        healthPanel.addChild(heart3)
        healthPanel.position = CGPoint(x: xCoord, y: yCoord)
        
        healthPanel.zPosition = 2
        
        parent.addChild(healthPanel)
    }
    
    // change the health of the player when hitting the monster
    func changeHealth(healthPoint: Int) {
        switch healthPoint {
        case 2:
            heart3.isHidden = true
        case 1:
            heart2.isHidden = true
        case 0:
            heart1.isHidden = true
        default:
            heart1.isHidden = false
            heart2.isHidden = false
            heart3.isHidden = false
        }
    }
    
    // update node position
    func updateHealthPos(newX: CGFloat, newY: CGFloat) {
        healthPanel.position = CGPoint(x: newX, y: newY)
    }
    
    // node for displaying player score
    let playerScoreLabel = SKLabelNode()
    func displayPlayerScore(xCoord: CGFloat, yCoord: CGFloat, score: Int) {
        playerScoreLabel.text = "Player Score: \(score)"
        playerScoreLabel.position = CGPoint(x: xCoord, y: yCoord)
        playerScoreLabel.fontName = "AvenirNext-Regular"
        playerScoreLabel.fontSize = 40
        playerScoreLabel.fontColor = UIColor.white
        playerScoreLabel.zPosition = 2
        
        parent.addChild(playerScoreLabel)
    }
    
    // change player score
    func changePlayerScore(newScore: Int) {
        playerScoreLabel.text = "Player Score: \(newScore)"
    }
    
    // displaying opponent score
    let AIScoreLabel = SKLabelNode()
    func displayAIScore(xCoord: CGFloat, yCoord: CGFloat, score: Int) {
        AIScoreLabel.text = "Opponent Score: \(score)"
        AIScoreLabel.position = CGPoint(x: xCoord, y: yCoord)
        AIScoreLabel.fontName = "AvenirNext-Regular"
        AIScoreLabel.fontSize = 40
        AIScoreLabel.fontColor = UIColor.white
        AIScoreLabel.zPosition = 2
        
        parent.addChild(AIScoreLabel)
    }
    
    // change opponent score
    func changeAIScore(newScore: Int) {
        AIScoreLabel.text = "Opponent Score: \(newScore)"
    }
    
    // update node position
    func updateScoreLabelPos(newX: CGFloat, newY: CGFloat) {
        playerScoreLabel.position = CGPoint(x: newX, y: newY)
        AIScoreLabel.position = CGPoint(x: newX, y: newY - 50)
    }
    
    // construct a dark background for other use
    let darkBackground = SKSpriteNode()
    private func setUpBackground(x: CGFloat, y: CGFloat) {
        darkBackground.color = UIColor.black
        darkBackground.zPosition = 20
        darkBackground.alpha = 0
        darkBackground.position = CGPoint(x: x, y: y)
        darkBackground.size = CGSize(width: parent.frame.width * 0.5, height: parent.frame.height * 0.5)
        parent.addChild(darkBackground)
        darkBackground.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    // displaying message after a round win (first reach 5 trophies)
    let messageLabel = SKLabelNode()
    let exitLabel = SKLabelNode()
    func roundWinDisplay(winner: String, xCoord: CGFloat, yCoord: CGFloat) {
        setUpBackground(x: xCoord, y: yCoord)
        messageLabel.zPosition = 21
        messageLabel.fontName = "AvenirNext-Bold"
        messageLabel.position = CGPoint(x: xCoord, y: yCoord + 100)
        messageLabel.fontColor = UIColor.white
        messageLabel.fontSize = 100
        messageLabel.alpha = 0
        
        exitLabel.zPosition = 21
        exitLabel.fontName = "AvenirNext-Bold"
        exitLabel.position = CGPoint(x: xCoord, y: yCoord - 100)
        exitLabel.fontColor = UIColor.white
        exitLabel.fontSize = 100
        exitLabel.alpha = 0
        exitLabel.text = "Exit"
        exitLabel.name = "exit"
        
        switch winner {
        case "player":
            messageLabel.text = "You won!"
        case "ai":
            messageLabel.text = "AI won!"
        default:
            print("---")
        }
        
        parent.addChild(messageLabel)
        parent.addChild(exitLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.messageLabel.run(SKAction.fadeIn(withDuration: 0.5))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.exitLabel.run(SKAction.fadeIn(withDuration: 0.5))
            }
        }
    }
    
    // constructing pause menu
    let pausedLabel1 = SKLabelNode()
    let returnLabel = SKLabelNode()
    func pauseGame(xCoord: CGFloat, yCoord: CGFloat) {
        setUpBackground(x: xCoord, y: yCoord)
        
        pausedLabel1.zPosition = 21
        pausedLabel1.fontName = "AvenirNext-Bold"
        pausedLabel1.fontColor = UIColor.white
        pausedLabel1.position = CGPoint(x: xCoord, y: yCoord + 150)
        pausedLabel1.fontSize = 120
        pausedLabel1.alpha = 0
        pausedLabel1.text = "Game Paused"
        
        returnLabel.zPosition = 21
        returnLabel.fontName = "AvenirNext-Bold"
        returnLabel.fontColor = UIColor.white
        returnLabel.position = CGPoint(x: xCoord, y: yCoord - 150)
        returnLabel.fontSize = 100
        returnLabel.text = "Return To Menu"
        returnLabel.name = "return"
        
        parent.addChild(pausedLabel1)
        parent.addChild(returnLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pausedLabel1.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 1), SKAction.fadeOut(withDuration: 1)])))
        }
        parent.pause.zPosition = 21
    }
    
    // remove pause menu
    func removePauseGame() {
        darkBackground.removeFromParent()
        pausedLabel1.removeAllActions()
        pausedLabel1.removeFromParent()
        returnLabel.removeFromParent()
        parent.pause.zPosition = 2
    }
    
    let message1 = SKLabelNode()
    let message2 = SKLabelNode()
    func playerDiedDisplay(xCoord: CGFloat, yCoord: CGFloat) {
        setUpBackground(x: xCoord, y: yCoord)
        
        message1.zPosition = 21
        message1.fontName = "AvenirNext-Bold"
        message1.fontColor = UIColor.white
        message1.position = CGPoint(x: xCoord, y: yCoord + 150)
        message1.fontSize = 130
        message1.text = "You Died!"
        
        message2.zPosition = 21
        message2.fontName = "AvenirNext-Bold"
        message2.fontColor = UIColor.white
        message2.position = CGPoint(x: xCoord, y: yCoord - 150)
        message2.fontSize = 100
        message2.text = "Try Again"
        message2.alpha = 0
        message2.name = "tryagain"
        
        parent.addChild(message1)
        parent.addChild(message2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.message2.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    func removePlayerDiedDisplay() {
        darkBackground.removeFromParent()
        message1.removeFromParent()
        message2.removeFromParent()
    }
    
    func endGame() {
        parent.joystick.disabled = true
        parent.pause.isHidden = true
        parent.player1.stop()
        parent.opponent.stop()
        parent.monster1.stop()
        parent.monster2.stop()
        
        parent.player1.player_Score = 0
        parent.player1.player_Health = 3
        parent.opponent.AI_Score = 0
    }
    
}
