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

class InfoDisplay {
    
    var parent: GameScene!
    
    private var healthPanel = SKSpriteNode()
    
    init(parent: GameScene) {
        self.parent = parent
    }
    
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
    
    func updateHealthPos(newX: CGFloat, newY: CGFloat) {
        healthPanel.position = CGPoint(x: newX, y: newY)
    }
    
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
    
    func changePlayerScore(newScore: Int) {
        playerScoreLabel.text = "Player Score: \(newScore)"
    }
    
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
    
    func changeAIScore(newScore: Int) {
        AIScoreLabel.text = "Opponent Score: \(newScore)"
    }
    
    func updateScoreLabelPos(newX: CGFloat, newY: CGFloat) {
        playerScoreLabel.position = CGPoint(x: newX, y: newY)
        AIScoreLabel.position = CGPoint(x: newX, y: newY - 50)
    }
    
}
