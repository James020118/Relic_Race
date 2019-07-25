//
//  SKLabelButtonNode.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-07-24.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

class SKLabelButtonNode: SKLabelNode {
    var onTouchesBegan: ((Set<UITouch>, UIEvent?) -> Void)? = nil
    var onTouchesEnded: ((Set<UITouch>, UIEvent?) -> Void)? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let onTouchesBegan = onTouchesBegan {
            onTouchesBegan(touches, event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let onTouchesEnded = onTouchesEnded {
            onTouchesEnded(touches, event)
        }
    }
}
