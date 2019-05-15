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


/*-----------------
 Viewcontroller to control the Game Screen
 -----------------*/
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Spritekit GameScene creation
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
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
