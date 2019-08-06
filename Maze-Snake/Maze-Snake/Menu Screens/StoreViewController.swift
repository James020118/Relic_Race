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
    
    var db: Firestore!
    var userData = [String : Any]()
    
    var userTrophyCount = 0
    var skins = [String]()
    var currentlyEquipped = ""
    
    @IBOutlet var playerModel: UIImageView!
    @IBOutlet var defaultOption: UIButton!
    @IBOutlet var skin1option: UIButton!
    @IBOutlet var skin2Option: UIButton!
    
    func setDisabledMode() {
        skin1option.isEnabled = false
        skin2Option.isEnabled = false
        let disabledString = "Sign in to buy"
        skin1option.setTitle(disabledString, for: UIControl.State.disabled)
        skin2Option.setTitle(disabledString, for: UIControl.State.disabled)
        skin1option.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        skin2Option.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        guard let currentUser = Auth.auth().currentUser else {
            setDisabledMode()
            return
        }
        if currentUser.isAnonymous {
            setDisabledMode()
            return
        }
        
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument(source: .cache, completion: { [unowned self] (document, error) in
            if error != nil {
                return
            }
            if let document = document, document.exists {
                self.userData = document.data() ?? [:]
                self.userTrophyCount = self.userData["currency"] as? Int ?? 0
                self.skins = self.userData["skins"] as? [String] ??  ["oldMan"]
                self.currentlyEquipped = self.userData["currentlyEquipped"] as? String ?? "oldMan"
                
                for skinName in self.skins {
                    switch skinName {
                    case "oldMan":
                        if skinName == self.currentlyEquipped {
                            self.defaultOption.setTitle("Equipped", for: .normal)
                        }
                    case "youngMan":
                        if skinName == self.currentlyEquipped {
                            self.skin1option.setTitle("Equipped", for: .normal)
                            self.playerModel.image = #imageLiteral(resourceName: "Young Man Close Up.png")
                        } else {
                            self.skin1option.setTitle("Equip", for: .normal)
                        }
                    case "gingerMan":
                        if skinName == self.currentlyEquipped {
                            self.skin2Option.setTitle("Equipped", for: .normal)
                            self.playerModel.image = #imageLiteral(resourceName: "Ginger man close up.png")
                        } else {
                            self.skin2Option.setTitle("Equip", for: .normal)
                        }
                    default:
                        print("hahahahahaha")
                    }
                    
                    
                }
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSkinClick(_ sender: UIButton) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        var skinBought = ""
        //Check if the player has enough trophies
        let cost = sender.tag * 50
        
        switch cost {
        case 150:
            skinBought = "youngMan"
        case 250:
            skinBought = "gingerMan"
        default:
            skinBought = "oldMan"
        }
        
        if currentUser.isAnonymous {
            sender.setTitle("Equipped", for: .normal)
            return
        }
        
        //Check if they have skin in online inventory
        if sender.titleLabel?.text == "Equip" {
            //Store choice
            for skinName in skins {
                if skinName == "oldMan" {
                    defaultOption.setTitle("Equip", for: .normal)
                } else if skinName == "youngMan" {
                    skin1option.setTitle("Equip", for: .normal)
                } else if skinName == "gingerMan" {
                    skin2Option.setTitle("Equip", for: .normal)
                }
            }
            
            currentlyEquipped = skinBought
            userData["currentlyEquipped"] = currentlyEquipped
            db.collection("users").document(currentUser.email!).setData(userData)
            switch skinBought {
            case "oldMan":
                playerModel.image = #imageLiteral(resourceName: "headass.png")
            case "youngMan":
                playerModel.image = #imageLiteral(resourceName: "Young Man Close Up.png")
            case "gingerMan":
                playerModel.image = #imageLiteral(resourceName: "Ginger man close up.png")
            default:
                playerModel.image = #imageLiteral(resourceName: "headass.png")
            }
            
            sender.setTitle("Equipped", for: .normal)
            return
        }
        
        if sender.titleLabel?.text == "Equipped" {
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
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { [unowned self] (_) -> Void in
                //If press "yes" take away coins give them the skin and equip it
                self.currentlyEquipped = skinBought
                self.userData["currentlyEquipped"] = self.currentlyEquipped
                
                switch skinBought {
                case "oldMan":
                    self.playerModel.image = #imageLiteral(resourceName: "headass.png")
                case "youngMan":
                    self.playerModel.image = #imageLiteral(resourceName: "Young Man Close Up.png")
                case "gingerMan":
                    self.playerModel.image = #imageLiteral(resourceName: "Ginger man close up.png")
                default:
                    self.playerModel.image = #imageLiteral(resourceName: "headass.png")
                }
                
                self.userTrophyCount -= cost
                self.skins.append(skinBought)
                
                for skinName in self.skins {
                    if skinName == "oldMan" {
                        self.defaultOption.setTitle("Equip", for: .normal)
                    } else if skinName == "youngMan" {
                        self.skin1option.setTitle("Equip", for: .normal)
                    } else if skinName == "gingerMan" {
                        self.skin2Option.setTitle("Equip", for: .normal)
                    }
                }
                sender.setTitle("Equipped", for: .normal)
                
                self.userData["currency"] = self.userTrophyCount
                self.userData["skins"] = self.skins
                
                self.db.collection("users").document(currentUser.email!).setData(self.userData)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }

}
