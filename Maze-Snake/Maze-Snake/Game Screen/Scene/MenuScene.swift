//
//  MenuScene.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-05-21.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let titleLabel = SKLabelNode()
    let pvp = SKLabelNode()
    let pvai = SKLabelNode()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        addTitle()
        addLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pvai" {
            removeAllChildren()
            let transition = SKTransition.fade(withDuration: 1)
            let gameScene = SKScene(fileNamed: "GameScene")!
            gameScene.scaleMode = .aspectFit
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    
    func addTitle() {
        titleLabel.zPosition = 1
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 400
        titleLabel.text = "Maze Runner"
        titleLabel.position = CGPoint(x: self.position.x, y: self.position.y + frame.height / 5)
        addChild(titleLabel)
    }
    
    func addLabels() {
        pvai.zPosition = 1
        pvai.fontName = "AvenirNext-Bold"
        pvai.fontColor = UIColor.white
        pvai.fontSize = 150
        pvai.text = "PvAI Mode"
        pvai.position = CGPoint(x: self.position.x - frame.width / 4, y: self.position.y - frame.height / 4)
        pvai.name = "pvai"
        
        pvp.zPosition = 1
        pvp.fontName = "AvenirNext-Bold"
        pvp.fontColor = UIColor.white
        pvp.fontSize = 150
        pvp.text = "PvP Mode"
        pvp.position = CGPoint(x: self.position.x + frame.width / 4, y: self.position.y - frame.height / 4)
        pvp.name = "pvp"
        
        addChild(pvai)
        addChild(pvp)
    }
    
}
