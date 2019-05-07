//
//  GameScene.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var tileManager: TileController!
    
    private var lastUpdateTime : TimeInterval = 0
    private var tileMap: SKTileMapNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        tileMap = childNode(withName: "tileMap") as? SKTileMapNode ?? SKTileMapNode()
        tileMap.isHidden = true
        
        let graph = blankGraph()
        
        tileManager = TileController(from: graph)//TileController(from: graphs["maze"] as? GKGridGraph<GKGridGraphNode> ?? GKGridGraph())
        tileManager.addTilesTo(scene: self)
        
        self.lastUpdateTime = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        print(tileManager.positionFrom(position: location))
        
        //let pos = tileManager.positionFrom(position: location)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
