//
//  SFXController.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-29.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import AVKit

class SFXController {
    
    
    var audioNodes: [String : SKAudioNode] = [:]
    let parent: GameScene
    
    
    init(from parent: GameScene) {
        self.parent = parent
    }
    
    
    /* Function that prepares sound effects */
    func preloadSounds(){
        //Array of sounds
        let sounds: [String] = ["death", "end", "footsteps", "game-over", "trophy-collect"]
        //Catch exceptions thrown
        do {
            //Iterate thriugh array
            for sound in sounds {
                let fileExtension = "wav"
                //Retrieve location
                let path:String = Bundle.main.path(forResource: sound, ofType: fileExtension)!
                //Create URL
                let url: URL = URL(fileURLWithPath: path)
                //Make AVAudioPlayer object
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                //Prepare for use
                player.prepareToPlay()
            }
            //Catch  block
        } catch {}
        
    }
    
    func playSound(named name: String, completion handler: (() -> Void)?) {
        let soundAction = SKAction.playSoundFileNamed(name, waitForCompletion: true)
        var actions = [soundAction]
        if handler != nil {
            let completion = SKAction.run(handler!)
            actions.append(completion)
        }
        let sequence = SKAction.sequence(actions)
        parent.run(sequence)
    }
    
}
