//
//  LeaderboardViewController.swift
//  Maze-Snake
//
//  Created by Ximing Yang on 2019-06-08.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allUsers = [[String : Any]]()
    var db: Firestore!
    
    var allEasyTime = [(name: String, time: Int)]()
    var allHardTime = [(name: String, time: Int)]()
    var allImpossibleTime = [(name: String, time: Int)]()
    
    @IBOutlet var difficultySegmentControl: UISegmentedControl!
    @IBOutlet var leaderboardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultySegmentControl.layer.cornerRadius = 5
        
        db = Firestore.firestore()
        
        db.collection("users").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting all user data for leaderboard, \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.allUsers.append(document.data())
                }
                print("Successfully got all user data for leaderboard.")
                
                for singleUser in self.allUsers {
                    //Put user's lowest time in Easy difficulty into the array
                    let nsEasy = singleUser["easyTime"] as! [NSNumber]
                    var intEasy = [Int]()
                    
                    for num in nsEasy {
                        intEasy.append(num.intValue)
                    }
                    if intEasy.count > 0 {
                        intEasy.sort()
                        self.allEasyTime.append((name: singleUser["name"] as! String, time: intEasy[0]))
                    }
                    
                    //Put user's lowest time in Hard difficulty into the array
                    let nsHard = singleUser["hardTime"] as! [NSNumber]
                    var intHard = [Int]()
                    
                    for num in nsHard {
                        intHard.append(num.intValue)
                    }
                    if intHard.count > 0 {
                        intHard.sort()
                        self.allHardTime.append((name: singleUser["name"] as! String, time: intHard[0]))
                    }
                    
                    //Put user's lowest time in Impossible difficulty into the array
                    let nsImpossible = singleUser["impossibleTime"] as! [NSNumber]
                    var intImpossible = [Int]()
                    
                    for num in nsImpossible {
                        intImpossible.append(num.intValue)
                    }
                    if intImpossible.count > 0 {
                        intImpossible.sort()
                        self.allImpossibleTime.append((name: singleUser["name"] as! String, time: intImpossible[0]))
                    }
                }
                
                self.allEasyTime.sort(by: { $0.time < $1.time })
                self.allHardTime.sort(by: { $0.time < $1.time })
                self.allImpossibleTime.sort(by: { $0.time < $1.time })
                
                self.leaderboardTable.reloadData()
            }
        }
        
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSegmentedControlClick(_ sender: Any) {
        leaderboardTable.reloadData()
    }
    
}



extension LeaderboardViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch difficultySegmentControl.selectedSegmentIndex {
        case 0:
            return allEasyTime.count
        case 1:
            return allHardTime.count
        case 2:
            return allImpossibleTime.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        cell.detailTextLabel?.textColor = UIColor.white
        
        switch difficultySegmentControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = "\(indexPath.row + 1): " + allEasyTime[indexPath.row].name
            cell.detailTextLabel?.text = "\(allEasyTime[indexPath.row].time)"
        case 1:
            cell.textLabel?.text = "\(indexPath.row + 1): " + allHardTime[indexPath.row].name
            cell.detailTextLabel?.text = "\(allHardTime[indexPath.row].time)"
        case 2:
            cell.textLabel?.text = "\(indexPath.row + 1): " + allImpossibleTime[indexPath.row].name
            cell.detailTextLabel?.text = "\(allImpossibleTime[indexPath.row].time)"
        default:
            break
        }
        
        if indexPath.row < 3 {
            cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
            cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
            cell.textLabel?.textColor = UIColor.init(displayP3Red: 255, green: 215, blue: 0, alpha: 1)
            cell.detailTextLabel?.textColor = UIColor.init(displayP3Red: 255, green: 215, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
