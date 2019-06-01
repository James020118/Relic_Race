//
//  PvPConnectionExt.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SpriteKit

extension PvPGameScene {
    
    
    func startHosting() {
        guard let mcSession = mcSession else { return }
        print("hosting")
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "maze-snake", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession() {
        guard let mcSession = mcSession else { return }
        print("joining")
        let mcBrowser = MCBrowserViewController(serviceType: "maze-snake", session: mcSession)
        mcBrowser.delegate = self
        parentVC.present(mcBrowser, animated: true)
    }
    
    
    /* Required Methods for Peer to Peer connections */
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //------ If data is initial payload
        if !startUpdateFlag {
            //Get Maze Data
            do {
                //Decode Data
                print(data)
                let buffer = try JSONDecoder().decode(MazeEncodingBuffer.self, from: data)
                let maze = Maze(from: buffer)
                graph = maze.graph
            }catch{
                //Update Game Positions
                fatalError()
            }
            //Init game
            hostSessionLabel.removeFromParent()
            joinSessionLabel.removeFromParent()
            cancelLabel.removeFromParent()
            super.sceneDidLoad()
            return
        }
        
        
        //----- If data is player position
        do {
            //Decode Data
            let gridPos = try JSONDecoder().decode(GridPosition.self, from: data)
            let newPos = tileManager.getTile(row: gridPos.row, column: gridPos.column).position
            opponent.position = newPos
            return
        }catch{ print("Data is not player pos") }
        
        
        //---- If data is score
        do {
            //Decode Data
            let packet = try JSONDecoder().decode(ScoringPacket.self, from: data)
            let gridPos = packet.pos
            let newPos = tileManager.getTile(row: gridPos.row, column: gridPos.column).position
            trophy.position = newPos
            minimap.updateTrophy(position: newPos)
            let value = packet.score
            if value != opponent.score {
                opponent.score = value
                info.changeAIScore(newScore: opponent.score)
                sfxController.playSound(named: "trophy-collect")
            }
            checkOpponentWin()
            return
        }catch{ print("Data is not scoring data") }
        
        
        //--- If opponent dies to monster
        let value = data.withUnsafeBytes {
            $0.load(as: UInt8.self)
        }
        if value == 1 {
            info.roundWinDisplay(winner: "player", xCoord: player1.position.x, yCoord: player1.position.y)
        }
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state: \(peerID.displayName)")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        confirmConnection()
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func pvpConnectionPrompt() {
        hostSessionLabel.zPosition = 1
        hostSessionLabel.fontName = "AvenirNext-Bold"
        hostSessionLabel.fontColor = UIColor.white
        hostSessionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 500)
        hostSessionLabel.fontSize = 200
        hostSessionLabel.text = "Host a Session"
        hostSessionLabel.name = "host"
        
        joinSessionLabel.zPosition = 1
        joinSessionLabel.fontName = "AvenirNext-Bold"
        joinSessionLabel.fontColor = UIColor.white
        joinSessionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        joinSessionLabel.fontSize = 200
        joinSessionLabel.text = "Join a Session"
        joinSessionLabel.name = "join"
        
        cancelLabel.zPosition = 1
        cancelLabel.fontName = "AvenirNext-Bold"
        cancelLabel.fontColor = UIColor.white
        cancelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 500)
        cancelLabel.fontSize = 200
        cancelLabel.text = "Cancel"
        cancelLabel.name = "cancel"
        
        addChild(hostSessionLabel)
        addChild(joinSessionLabel)
        addChild(cancelLabel)
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession?.delegate = self
    }
    
    
    func confirmConnection() {
        hostSessionLabel.removeFromParent()
        joinSessionLabel.removeFromParent()
        cancelLabel.removeFromParent()
        
        connectedLabel.zPosition = 1
        connectedLabel.fontName = "AvenirNext-Bold"
        connectedLabel.fontColor = UIColor.white
        connectedLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 250)
        connectedLabel.fontSize = 300
        connectedLabel.text = "Connected!"
        
        nextLabel.zPosition = 1
        nextLabel.fontName = "AvenirNext-Bold"
        nextLabel.fontColor = UIColor.white
        nextLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        nextLabel.fontSize = 300
        nextLabel.text = "Next"
        nextLabel.name = "next"
        
        addChild(connectedLabel)
        addChild(nextLabel)
    }
}
