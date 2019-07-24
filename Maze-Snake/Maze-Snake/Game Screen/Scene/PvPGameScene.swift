//
//  PvPGameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-28.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class PvPGameScene: GameScene, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var checksumHash = ""
    
    var outputStream:OutputStream?
    
    var streamedMap: Data? = Data()
    
    //Labels for initial prompt
    var hostSessionLabel = SKLabelNode()
    var joinSessionLabel = SKLabelNode()
    var cancelLabel = SKLabelNode()
    var connectedLabel = SKLabelNode()
    var nextLabel = SKLabelNode()
    
    //MPC Properties
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    //Storing Host-generated game properties
    var graph: GKGridGraph<GKGridGraphNode>?
    var sharedMonsters = [Monster]()
    
    
    /* Lifecycle Functions */
    
    override func sceneDidLoad() {
        pvpConnectionPrompt()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Get element at touch pos
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "exit" || node.name == "return" {
            mcSession?.disconnect()
        }
        super.touchesBegan(touches, with: event)
        
        if node.name == "host" {
            startHosting()
            hostSessionLabel.color = .black
        }
        
        //Executed when user decides to join an existing session in pvp mode
        if node.name == "join" {
            joinSession()
            joinSessionLabel.color = .black
        }
        
        //Executed when user leaves session creation menu
        if node.name == "cancel" {
            leave()
        }
        
        //Executed when two devices are connected and the user is proceedint to the game in pvp mode
        if node.name == "next" {
            do {
                setupStream()
                
                let buffer = makeGameData()
                let encoder = JSONEncoder()
                let data = try encoder.encode(buffer)
                //Send over checksum
                let checksum = ChecksumPacket(
                    hash: NSData(data: data).MD5()
                )
                let checksumData = try encoder.encode(checksum)
                try mcSession?.send(checksumData, toPeers: mcSession!.connectedPeers, with: .reliable)
                //Stream Map Data
                let writtenData = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
                outputStream?.close()
                
                //Initialize the game
                connectedLabel.removeFromParent()
                nextLabel.removeFromParent()
                setupGame()
            }  catch let error as NSError {
                print("Error sending over data = \(error)")
            }
        }
        
    }
    
    var lastSent: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        let dSent = currentTime - lastSent
        if dSent >= 0.33 && startUpdateFlag {
            let sendPos = player1.gridPos
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(sendPos)
                try mcSession?.send(data, toPeers: mcSession!.connectedPeers, with: .reliable)
            }catch{
                print("Oops!")
            }
            lastSent = currentTime
        }
        
    }
    
    
    /* Overriding Preferences in Base Game Generation */
    override func generateOpponent() {
        opponent = OtherPlayer(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    override func makeMaze() -> GKGridGraph<GKGridGraphNode> {
        return graph ?? blankGraph()
    }
    
    override func generateMonsters() -> [Monster] {
        return sharedMonsters
    }
    
    override func opponentToTrophyResponse() { }
    
    override func playerToTrophyResponse() {
        super.playerToTrophyResponse()
        let packet = ScoringPacket(
            score: player1.player_Score,
            pos: tileManager!.indexFrom(position: trophy!.position)
        )
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(packet)
            try mcSession?.send(data, toPeers: mcSession!.connectedPeers, with: .reliable)
        }catch{
            print("Oops!")
        }
    }
    
    override func checkMonsterWin() {
        do {
            var val: UInt8 = 1
            let data = Data(bytes: &val, count: MemoryLayout<UInt8>.size)
            try mcSession?.send(data, toPeers: mcSession!.connectedPeers, with: .reliable)
        }catch{
            print("Oops!")
        }
        super.checkMonsterWin()
    }
    
    
    /* GAME -> SENDABLE DATA */
    
    func makeGameData() -> GameEncodingBuffer {
        premapSetup()
        let maze = makeMazeData()
        tileSetup()
        let monsters = super.generateMonsters()
        sharedMonsters = monsters
        let buffer = GameEncodingBuffer(from: maze, and: monsters)
        
        return buffer
    }
    
    func makeMazeData() -> Maze {
        //Generate Maze
        let maze = Maze(width: Maze.MAX_COLUMNS, height: Maze.MAX_ROWS)
        mazeGraph = maze.graph
        graph = maze.graph
        
        return maze
    }
    
}
