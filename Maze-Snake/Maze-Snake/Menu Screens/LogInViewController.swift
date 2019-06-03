//
//  LogInViewController.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-06-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    var db: Firestore!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        errorLabel.text = ""
    }
    
    //Detects if there is already a user signed in
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "logInToGame", sender: self)
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        logIn(sender: sender)
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: sender)
    }
    
    func logIn(sender: Any) {
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                self.performSegue(withIdentifier: "logInToGame", sender: sender)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                self.errorLabel.text = "Error: \(error!.localizedDescription)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.errorLabel.text = ""
                }
            }
        }
    }
    
    @IBAction func unwindToLogIn(unwind: UIStoryboardSegue) {}
    
}
