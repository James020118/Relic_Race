//
//  GameViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum Difficulty {
    case Easy, Hard, Impossible
}

/*-----------------
 Viewcontroller to control the Game Screen
 -----------------*/
class GameViewController: UIViewController {

    var difficulty: Difficulty = .Easy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch difficulty {
        case .Easy:
            AI.TILE_TIME = 0.55
        case .Hard:
            AI.TILE_TIME = 0.35
        case .Impossible:
            AI.TILE_TIME = 0.25
        }
        
        //Spritekit GameScene creation
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                //Store Instance
                scene.parentVC = self
                // Present the scene
                view.presentScene(scene)
            }
            
            //Optional Scene Settings
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsDrawCount = true
            view.showsPhysics = false
            view.shouldCullNonVisibleNodes = false
        }
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
