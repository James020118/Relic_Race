//
//  SoundController.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-29.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import AVKit

class SoundController {
    var musicPlayer = AVAudioPlayer()
    
    /* Function that prepares song to be played */
    func prepareMusicandSession(){
        //Catch exceptions thrown
        do {
            //Create new AVAudioPlayer from URL
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background-music", ofType: "wav")!))
            //Prepare song files
            musicPlayer.prepareToPlay()
            //Infinite looping
            musicPlayer.numberOfLoops = Int.max
            
            //Create shared instance
            let audioSession = AVAudioSession.sharedInstance()
            //Catch exceptioons thrown
            do {
                //Set category
                try audioSession.setCategory(AVAudioSession.Category.playback)
            } catch let sessionError {
                //Catch block
                print(sessionError)
            }
            
        } catch let musicPlayerError {
            //Catch block
            print(musicPlayerError)
        }
        
    }
    
    func play(at vol: Float) {
        //Set volume
        musicPlayer.volume = vol
        musicPlayer.play()
    }
    
    func stop() {
        musicPlayer.stop()
    }
    
}
