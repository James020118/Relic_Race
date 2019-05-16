import Foundation
import SpriteKit

class Actor: SKSpriteNode {
    
    //COLUMN - X
    //ROW - Y
    var gridPos: GridPosition
    
    init(texture: SKTexture?, parent: GameScene, pos: GridPosition) {
        let dim = parent.tileManager.getTile(row: 0, column: 0).size
        let size = CGSize(width: dim.width - 20, height: dim.height - 20)
        self.gridPos = pos
        super.init(texture: texture, color: .clear, size: size)
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gridPos = GridPosition(column: 0, row: 0)
        super.init(coder: aDecoder)
    }
    
    func stop() {
        self.removeAllActions()
    }
    
}
