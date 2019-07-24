//
//  View Controller Stack Shortcut.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-07-24.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
