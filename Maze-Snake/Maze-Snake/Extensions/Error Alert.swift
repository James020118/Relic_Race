//
//  Error Alert.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-07-24.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import UIKit

func showConnectionErrorAlert(message: String, vc: UIViewController, completionHandler: ((UIAlertAction) -> Void)?) {
    let alert = UIAlertController(title: "Connection Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: completionHandler))
    vc.present(alert, animated: true)
}
