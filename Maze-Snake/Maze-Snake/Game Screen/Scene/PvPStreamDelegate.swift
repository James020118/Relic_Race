//
//  PvPStreamDelegate.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-07-22.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

extension PvPGameScene: StreamDelegate {
    
    func setupStream() {
        do {
            try outputStream = mcSession?.startStream(withName: "map-data", toPeer: mcSession!.connectedPeers[0])
            
            if let outputStream = outputStream {
                outputStream.delegate = self
                outputStream.schedule(
                    in: RunLoop.main,
                    forMode:RunLoop.Mode.default
                )
                outputStream.open()
            }
        }catch {
            print("Error in beginSession() = \(error)")
        }
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        let MAX_DATA_SIZE = 1024
        switch(eventCode){
        case Stream.Event.hasBytesAvailable:
            let input = aStream as! InputStream
            var buffer = [UInt8](repeating: 0, count: MAX_DATA_SIZE) //allocate a buffer. The size of the buffer will depended on the size of the data you are sending.
            let numberBytes = input.read(&buffer, maxLength: MAX_DATA_SIZE)
            let data = NSData(bytes: &buffer, length: numberBytes) as Data
            streamedMap?.append(data)
            break
        //input
        case Stream.Event.hasSpaceAvailable:
            break
        //output
        case Stream.Event.endEncountered:
            //Get Maze Data
            do {
                //Decode Data
                print(streamedMap!)
                let receivingHsah = NSData(data: streamedMap!).MD5()
                if receivingHsah != checksumHash {
                    leave()
                    return
                }
                
                let buffer = try JSONDecoder().decode(GameEncodingBuffer.self, from: streamedMap!)
                premapSetup()
                let maze = Maze(from: buffer)
                mazeGraph = maze.graph
                graph = maze.graph
                tileSetup()
                sharedMonsters = buffer.getMonsters(from: self)
            }catch{
                leave()
            }
            //Init game
            hostSessionLabel.removeFromParent()
            joinSessionLabel.removeFromParent()
            cancelLabel.removeFromParent()
            setupGame()
            aStream.close()
            break
        default:
            break
        }
    }
}
