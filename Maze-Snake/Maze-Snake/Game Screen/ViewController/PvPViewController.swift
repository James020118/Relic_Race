//
//  PvPViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PvPViewController: UIViewController {

    var soundController: SoundController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundController = SoundController()
        soundController.prepareMusicandSession()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "PvPGameScene") as? PvPGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                //Store Instance
                scene.parentVC = self
                // Present the scene
                view.presentScene(scene)
            }
            
            //Optional Scene Settings
            view.ignoresSiblingOrder = true
            view.shouldCullNonVisibleNodes = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if music_Is_On {
            soundController.play(at: 0.15)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if music_Is_On {
            soundController.stop()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
