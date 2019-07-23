//
//  MainViewController.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

var joystick_On_The_Right = true
var minimap_On_The_Left = true
var music_Is_On = true

var playerTexture = ""

class MainViewController: UIViewController {
    
    var db: Firestore!
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var playerModelSmall: UIImageView!
    
    var currentlyEquipped = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
        if data.object(forKey: "joystickPos") != nil && data.object(forKey: "minimapPos") != nil && data.object(forKey: "musicOn") != nil {
            joystick_On_The_Right = data.bool(forKey: "joystickPos")
            minimap_On_The_Left = data.bool(forKey: "minimapPos")
            music_Is_On = data.bool(forKey: "musicOn")
        } else {
            data.set(true, forKey: "joystickPos")
            data.set(true, forKey: "minimapPos")
            data.set(true, forKey: "musicOn")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser!
        welcomeLabel.text = "Welcome, \(currentUser.displayName!)!"
        if Auth.auth().currentUser!.isAnonymous {
            welcomeLabel.text = "Welcome, Guest!"
            playerTexture = "oldMan"
            return
        }
        
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument { [unowned self] (document, error) in
            if let document = document, document.exists {
                let currency = document.data()!["currency"] as? Int ?? 0
                self.currencyLabel.text = "Relics: \(currency)"
                self.currentlyEquipped = document.data()!["currentlyEquipped"] as? String ?? "oldMan"
                
                switch self.currentlyEquipped {
                case "oldMan":
                    self.playerModelSmall.image = #imageLiteral(resourceName: "headass.png")
                case "youngMan":
                    self.playerModelSmall.image = #imageLiteral(resourceName: "Young Man Close Up.png")
                case "gingerMan":
                    self.playerModelSmall.image = #imageLiteral(resourceName: "Ginger man close up.png")
                default:
                    self.playerModelSmall.image = #imageLiteral(resourceName: "headass.png")
                }
                
                playerTexture = self.currentlyEquipped
            }
        }
        

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [unowned self] (_) in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onAdClick(_ sender: Any) {
        let videoLoaded = GADRewardBasedVideoAd.sharedInstance().isReady
        if videoLoaded {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

}
