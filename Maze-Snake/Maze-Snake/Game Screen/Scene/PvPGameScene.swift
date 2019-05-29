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
    
    //Labels for initial prompt
    var hostSessionLabel = SKLabelNode()
    var joinSessionLabel = SKLabelNode()
    var cancelLabel = SKLabelNode()
    
    var connectedLabel = SKLabelNode()
    var nextLabel = SKLabelNode()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    var graph: GKGridGraph<GKGridGraphNode>?
    
    override func sceneDidLoad() {
        pvpConnectionPrompt()
    }
    
    override func generateOpponent() {
        opponent = OtherPlayer(texture: SKTexture(image: #imageLiteral(resourceName: "player.png")), parent: self, pos: GridPosition(column: 1, row: Maze.MAX_ROWS-1))
        opponent.name = "ai"
    }
    
    override func makeMaze() -> GKGridGraph<GKGridGraphNode> {
        return graph ?? blankGraph()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //Get element at touch pos
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "host" {
            startHosting()
        }
        
        //Executed when user decides to join an existing session in pvp mode
        if node.name == "join" {
            joinSession()
        }
        
        //Executed when user leaves session creation menu
        if node.name == "cancel" {
            removeAllChildren()
            parentVC.dismiss(animated: true, completion: nil)
        }
        
        //Executed when two devices are connected and the user is proceedint to the game in pvp mode
        if node.name == "next" {
            let buffer = makeGraphData()
            print(buffer.tiles)
            print("")
            Maze(from: buffer).outputConnections()
            print("")
            var data: Data!
            let encoder = JSONEncoder()
            do {
                data = try encoder.encode(buffer)
            }catch{
                data = Data(base64Encoded: "")
            }
            print(buffer)
            do {
                try mcSession?.send(data, toPeers: mcSession!.connectedPeers, with: .reliable)
            }catch{
                print("Oops!")
            }
            //Initialize the game
            super.sceneDidLoad()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    func makeGraphData() -> MazeEncodingBuffer {
        //Generate Maze
        let maze = Maze(width: Maze.MAX_COLUMNS, height: Maze.MAX_ROWS)
        mazeGraph = maze.graph
        graph = mazeGraph ?? blankGraph()
        return MazeEncodingBuffer(from: maze)
    }
    
}
