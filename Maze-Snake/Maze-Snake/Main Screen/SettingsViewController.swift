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
    
    @IBOutlet weak var joystickLabel: UILabel!
    @IBOutlet weak var minimapLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Data
        if data.object(forKey: "joystickPos") != nil && data.object(forKey: "minimapPos") != nil {
            joystick_On_The_Right = data.bool(forKey: "joystickPos")
            minimap_On_The_Left = data.bool(forKey: "minimapPos")
        } else {
            data.set(true, forKey: "joystickPos")
            data.set(true, forKey: "minimapPos")
        }
        //Setup UI based on Preference
        setupOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Dynanically set-font
        joystickLabel.fitTextToBounds()
        minimapLabel.fitTextToBounds()
    }
    
    @IBAction func onLeftJoystickClick(_ sender: Any) {
        data.set(false, forKey: "joystickPos")
        joystick_On_The_Right = false
        setupOptions()
    }
    @IBAction func onRightJoystickClick(_ sender: Any) {
        data.set(true, forKey: "joystickPos")
        joystick_On_The_Right = true
        setupOptions()
    }
    
    @IBAction func onLeftMinimapClick(_ sender: Any) {
        data.set(true, forKey: "minimapPos")
        minimap_On_The_Left = true
        setupOptions()
    }
    @IBAction func onRightMinimapClick(_ sender: Any) {
        data.set(false, forKey: "minimapPos")
        minimap_On_The_Left = false
        setupOptions()
    }
    
    
    func setupOptions() {
        if joystick_On_The_Right {
            joystick_Position_Right.setTitleColor(.green, for: .normal)
            joystick_Position_Left.setTitleColor(.white, for: .normal)
        }else {
            joystick_Position_Left.setTitleColor(.green, for: .normal)
            joystick_Position_Right.setTitleColor(.white, for: .normal)
        }
        if minimap_On_The_Left {
            minimap_Position_Left.setTitleColor(.green, for: .normal)
            minimap_Position_Right.setTitleColor(.white, for: .normal)
        }else {
            minimap_Position_Right.setTitleColor(.green, for: .normal)
            minimap_Position_Left.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
