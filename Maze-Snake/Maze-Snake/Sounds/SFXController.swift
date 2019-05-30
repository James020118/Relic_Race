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
    
    
    func preloadSounds(){
        let sounds: [String] = ["death", "end", "footsteps", "game-over", "trophy-collect"]

        for sound in sounds {
            //Get Sound Bundle
            let fileExtension = "wav"
            let path:String = Bundle.main.path(forResource: sound, ofType: fileExtension)!
            let url: URL = URL(fileURLWithPath: path)
            //Create Audionode to play
            let node = SKAudioNode(url: url)
            audioNodes[sound] = node
            node.autoplayLooped = false
            if sound == "footsteps" {
                node.autoplayLooped = true
            }
            parent.addChild(node)
        }
        
    }
    
    
    func playSound(named name: String, completion handler: (() -> Void)?) {
        guard let node = audioNodes[name] else {
            return
        }
        let playAction = SKAction.play()
        node.run(playAction)
    }
    
    
    func stopSound(named name: String) {
        guard let node = audioNodes[name] else {
            return
        }
        node.removeAllActions()
        node.run(SKAction.stop())
    }
    
    
}
