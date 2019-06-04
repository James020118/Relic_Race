//
//  SignUpViewController.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-06-03.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var db: Firestore!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        errorLabel.text = ""
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        signUp()
    }
    
    @IBAction func goToLogIn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func signUp() {
        //Get data from user
        guard let username = nameTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        //Authenticate the user
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("Successfully created user!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        print("User display name changed!")
                    }
                })
                
                //Create user file on database
                self.db.collection("users").document(email).setData([
                    "email": email,
                    "password": password,
                    "name": username,
                    "currency": 0
                ]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written")
                    }
                }
                
                self.errorLabel.textColor = UIColor.green
                self.errorLabel.text = "Success! Please Log In."
            } else {
                print("Error creating user: \(error!.localizedDescription)")
                self.errorLabel.textColor = UIColor.red
                self.errorLabel.text = "Error: \(error!.localizedDescription)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.errorLabel.text = ""
                }
            }
        }
        
        
        
    }
    
}
