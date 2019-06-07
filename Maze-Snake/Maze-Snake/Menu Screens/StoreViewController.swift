//
//  StoreViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-06-05.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet var playerModel: UIImageView!
    @IBOutlet var skin1option: UIButton!
    @IBOutlet var skin2Option: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func onDefaultClick(_ sender: Any) {
    }
    
    @IBAction func onOption2Click(_ sender: Any) {
    }
    
    @IBAction func onOption1Click(_ sender: Any) {
        //Check if they have skin in online inventory
        
        //Check if the player has enough trophies
        
        //If not popup with "You do not have enough trophies"
        
        //If so present a confirmation alert to buy
        
        //If press "yes" take away coins give them the skin and equip it
    }
    
    //TODO:- Add skin inventory to AIGameScene firebase modifications
        //Create new user, add a string array with default skin in it
    
    //TODO:- First time user launches the app write the file with list of skins
    //in Appdelegate if file doesnt exist write new file and get skin data from firebase

}
