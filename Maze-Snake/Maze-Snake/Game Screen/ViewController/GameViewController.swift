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
import GoogleMobileAds

enum Difficulty {
    case Easy, Hard, Impossible
}

/*-----------------
 Viewcontroller to control the Game Screen
 -----------------*/
class GameViewController: UIViewController, GADInterstitialDelegate {

    var soundController: SoundController!
    
    weak var aiGame: AIGameScene?
    
    var difficulty: Difficulty = .Easy
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundController = SoundController()
        soundController.prepareMusicandSession()
        
        switch difficulty {
        case .Easy:
            TILE_TIME = 0.37
        case .Hard:
            TILE_TIME = 0.27
        case .Impossible:
            TILE_TIME = 0.19
        }
        
        DispatchQueue.main.async {
            //Spritekit GameScene creation
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "AIGameScene") as? AIGameScene {
                    self.aiGame = scene
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    //Store Instance
                    scene.parentVC = self
                    //Assgin Difficulty
                    scene.difficulty = self.difficulty
                    // Present the scene
                    view.presentScene(scene)
                }
                
                //Optional Scene Settings
                view.ignoresSiblingOrder = true
                view.shouldCullNonVisibleNodes = false
            }
        }
        
        //PRELOAD & CONFIGURE ADS
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: INTERSTITIAL_UNIT_ID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    override func viewWillAppear(_ animated: Bool) {
        if music_Is_On {
           soundController.play(at: 0.15)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
