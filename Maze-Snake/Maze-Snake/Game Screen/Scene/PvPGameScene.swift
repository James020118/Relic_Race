//
//  PvPGameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity

class PvPGameScene: GameScene, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //Labels for initial prompt
    var hostSessionLabel = SKLabelNode()
    var joinSessionLabel = SKLabelNode()
    var cancelLabel = SKLabelNode()
    
    var connectedLabel = SKLabelNode()
    var nextLabel = SKLabelNode()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func sceneDidLoad() {
//        initializeGame(type: "u-opp")
        pvpConnectionPrompt()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //Get element at touch pos
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "host" {
            startHosting()
        }
        
        //Executed when user decides to join an existing session in pvp mode
        if node.name == "join" {
            joinSession()
        }
        
        //Executed when user leaves session creation menu
        if node.name == "cancel" {
            removeAllChildren()
            parentVC.dismiss(animated: true, completion: nil)
        }
        
        //Executed when two devices are connected and the user is proceedint to the game in pvp mode
        if node.name == "next" {
            //Initialize the game
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
}
