//
//  MainViewController.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-05-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import Firebase

var joystick_On_The_Right = true
var minimap_On_The_Left = true
var music_Is_On = true

class MainViewController: UIViewController {
    
    var db: Firestore!
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
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
        
        let currentUser = Auth.auth().currentUser!
        welcomeLabel.text = "Welcome, \(currentUser.displayName!)"
        
        let docRef = db.collection("users").document(currentUser.email!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currency = document.data()!["currency"] as! Int
                self.currencyLabel.text = "Currency: \(currency)"
            }
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
