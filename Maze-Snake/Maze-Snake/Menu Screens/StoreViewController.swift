//
//  StoreViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-06-05.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import Firebase

class StoreViewController: UIViewController {
    
    let currentUser = Auth.auth().currentUser!
    
    var db: Firestore!
    var userData = [String : Any]()
    
    var userTrophyCount = 0
    var skins = [String]()
    
    @IBOutlet var playerModel: UIImageView!
    @IBOutlet var skin1option: UIButton!
    @IBOutlet var skin2Option: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userData = document.data() ?? [:]
                self.userTrophyCount = self.userData["currency"] as? Int ?? 0
                self.skins = self.userData["skins"] as? [String] ??  ["oldMan"]
                
                for skinName in self.skins {
                    switch skinName {
                    case "otherMan1":
                        self.skin1option.setTitle("Equip", for: .normal)
                    case "otherMan2":
                        self.skin2Option.setTitle("Equip", for: .normal)
                    default:
                        print("hahahahahaha")
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSkinClick(_ sender: UIButton) {
        var skinBought = ""
        //Check if the player has enough trophies
        let cost = sender.tag * 50
        
        switch cost {
        case 150:
            skinBought = "otherMan1"
        case 250:
            skinBought = "otherMan2"
        default:
            skinBought = "oldMan"
        }
        
        //Check if they have skin in online inventory
        if sender.titleLabel?.text == "Equip" {
            //Store choice
            data.set(skinBought, forKey: EQUIPPED_KEY)
            return
        }
        
        let trophies = userTrophyCount//Trophies
        //If not popup with "You do not have enough trophies"
        if cost > trophies {
            Toast().showAlert(
                backgroundColor: UIColor.white,
                textColor: UIColor.black,
                message: "Not enough Relics"
            )
            return
        }
        //If so present a confirmation alert to buy
        if cost <= trophies {
            let alert = UIAlertController(title: "Confirm Purchase of \(cost) Relics for skin", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (_) -> Void in
                //If press "yes" take away coins give them the skin and equip it
                sender.setTitle("Equip", for: .normal)
                data.set(skinBought, forKey: EQUIPPED_KEY)
                self.userTrophyCount -= cost
                self.skins.append(skinBought)
                
                self.userData["currency"] = self.userTrophyCount
                self.userData["skins"] = self.skins
                
                self.db.collection("users").document(self.currentUser.email!).setData(self.userData)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }

}
