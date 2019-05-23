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

//A class for displaying various information in the game scene
class InfoDisplay {
    
    //Parent scene
    var parent: GameScene!
    
    //Node for displaying health
    private var healthPanel = SKSpriteNode()
    
    init(parent: GameScene) {
        self.parent = parent
    }
    
    //Constructing node for displaying health
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
    
    //Change the health of the player when hitting the monster
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
    
    //Update node position
    func updateHealthPos(newX: CGFloat, newY: CGFloat) {
        healthPanel.position = CGPoint(x: newX, y: newY)
    }
    
    //Node for displaying player score
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
    
    //Change player score
    func changePlayerScore(newScore: Int) {
        playerScoreLabel.text = "Player Score: \(newScore)"
    }
    
    //Displaying opponent score
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
    
    //Change opponent score
    func changeAIScore(newScore: Int) {
        AIScoreLabel.text = "Opponent Score: \(newScore)"
    }
    
    //Update node position
    func updateScoreLabelPos(newX: CGFloat, newY: CGFloat) {
        playerScoreLabel.position = CGPoint(x: newX, y: newY)
        AIScoreLabel.position = CGPoint(x: newX, y: newY - 50)
    }
    
    //Construct a dark background for other use
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
    
    //Displaying message after a round win (first reach 5 trophies)
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
    
    //Constructing pause menu
    let pausedLabel1 = SKLabelNode()
    let returnLabel = SKLabelNode()
    let settingsLabel = SKLabelNode()
    func pauseGame(xCoord: CGFloat, yCoord: CGFloat) {
        setUpBackground(x: xCoord, y: yCoord)
        
        pausedLabel1.zPosition = 21
        pausedLabel1.fontName = "AvenirNext-Bold"
        pausedLabel1.fontColor = UIColor.red
        pausedLabel1.position = CGPoint(x: xCoord, y: yCoord + 150)
        pausedLabel1.fontSize = 120
        pausedLabel1.alpha = 0
        pausedLabel1.text = "Game Paused"
        
        returnLabel.zPosition = 21
        returnLabel.fontName = "AvenirNext-Bold"
        returnLabel.fontColor = UIColor.white
        returnLabel.position = CGPoint(x: xCoord, y: yCoord - 75)
        returnLabel.fontSize = 100
        returnLabel.text = "Return To Menu"
        returnLabel.name = "return"
        
        settingsLabel.name = "settings"
        settingsLabel.zPosition = 21
        settingsLabel.fontName = "AvenirNext-Bold"
        settingsLabel.fontColor = UIColor.white
        settingsLabel.fontSize = 100
        settingsLabel.text = "Settings"
        settingsLabel.position = CGPoint(x: xCoord, y: yCoord - 250)
        
        parent.addChild(pausedLabel1)
        parent.addChild(returnLabel)
        parent.addChild(settingsLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pausedLabel1.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 1), SKAction.fadeOut(withDuration: 1)])))
        }
        parent.pause.zPosition = 21
    }
    
    //Remove pause menu from the parent
    func removePauseGame() {
        darkBackground.removeFromParent()
        pausedLabel1.removeAllActions()
        pausedLabel1.removeFromParent()
        returnLabel.removeFromParent()
        settingsLabel.removeFromParent()
        parent.pause.zPosition = 2
    }
    
    //Called when the player's health reaches 0, gives player an option to try again
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

    //Settings menu
    let LABEL_MOVE_OFFSET: CGFloat = 575
    
    let back = SKLabelNode()
    let moveJoystick_Title = SKLabelNode()
    let moveJoystick_Right = SKLabelNode()
    let moveJoystck_Left = SKLabelNode()
    func goToSettings(xCoord: CGFloat, yCoord: CGFloat) {
        pausedLabel1.isHidden = true
        pausedLabel1.isHidden = true
        returnLabel.isHidden = true
        parent.pause.isHidden = true
        settingsLabel.run(SKAction.moveTo(y: settingsLabel.position.y + LABEL_MOVE_OFFSET, duration: 1))
        
        back.zPosition = 21
        back.fontName = "AvenirNext-Bold"
        back.fontColor = UIColor.white
        back.position = CGPoint(x: xCoord - 725, y: yCoord + 350)
        back.fontSize = 100
        back.text = "Back"
        back.name = "back"
        
        moveJoystick_Title.zPosition = 21
        moveJoystick_Title.fontName = "AvenirNext-Bold"
        moveJoystick_Title.fontColor = UIColor.white
        moveJoystick_Title.position = CGPoint(x: xCoord - 300, y: yCoord + 50)
        moveJoystick_Title.fontSize = 100
        moveJoystick_Title.text = "Hud(joystick) Position: "
        
        moveJoystick_Right.zPosition = 21
        moveJoystick_Right.fontName = "AvenirNext-Bold"
        if parent.joystick_On_The_Right {
            moveJoystick_Right.fontColor = UIColor.green
        } else {
            moveJoystick_Right.fontColor = UIColor.white
        }
        moveJoystick_Right.position = CGPoint(x: xCoord + 425, y: yCoord + 50)
        moveJoystick_Right.fontSize = 100
        moveJoystick_Right.text = "right"
        moveJoystick_Right.name = "joystick_right"
        
        moveJoystck_Left.zPosition = 21
        moveJoystck_Left.fontName = "AvenirNext-Bold"
        if !parent.joystick_On_The_Right {
            moveJoystck_Left.fontColor = UIColor.green
        } else {
            moveJoystck_Left.fontColor = UIColor.white
        }
        moveJoystck_Left.position = CGPoint(x: xCoord + 700, y: yCoord + 50)
        moveJoystck_Left.fontSize = 100
        moveJoystck_Left.text = "left"
        moveJoystck_Left.name = "joystick_left"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.parent.addChild(self.back)
            self.parent.addChild(self.moveJoystick_Title)
            self.parent.addChild(self.moveJoystick_Right)
            self.parent.addChild(self.moveJoystck_Left)
        }
    }
    
    //Remove all nodes related to settings
    func exitSettings() {
        settingsLabel.run(SKAction.moveTo(y: settingsLabel.position.y - LABEL_MOVE_OFFSET, duration: 1))
        back.removeFromParent()
        moveJoystick_Title.removeFromParent()
        moveJoystick_Right.removeFromParent()
        moveJoystck_Left.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pausedLabel1.isHidden = false
            self.pausedLabel1.isHidden = false
            self.returnLabel.isHidden = false
            self.parent.pause.isHidden = false
        }
    }
    
    //Stop all actions to get ready to reset the game
    func endGame() {
        parent.joystick.disabled = true
        parent.pause.isHidden = true
        parent.player1.stop()
        parent.opponent.stop()
        
        for monster in parent.monsters {
            monster.stop()
        }
        
        parent.player1.player_Score = 0
        parent.player1.player_Health = 3
        parent.opponent.AI_Score = 0
    }
    
}
