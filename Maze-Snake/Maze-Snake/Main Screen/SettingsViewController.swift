//
//  SettingsViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-24.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var joystick_Position_Left: UIButton!
    @IBOutlet var joystick_Position_Right: UIButton!
    @IBOutlet var minimap_Position_Left: UIButton!
    @IBOutlet var minimap_Position_Right: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
