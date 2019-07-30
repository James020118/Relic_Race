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
    
    let LIMIT = 10
    
    //Worldwide and Local Top Scores
    var allEasyTime = [[(name: String, time: Int)](), [(name: String, time: Int)]()]
    var allHardTime = [[(name: String, time: Int)](), [(name: String, time: Int)]()]
    var allImpossibleTime = [[(name: String, time: Int)](), [(name: String, time: Int)]()]
    
    //Local
    var userEasyTime = [(name: String, time: Int)]()
    var userHardTime = [(name: String, time: Int)]()
    var userImpossibleTime = [(name: String, time: Int)]()
    
    @IBOutlet var difficultySegmentControl: UISegmentedControl!
    @IBOutlet var leaderboardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultySegmentControl.layer.cornerRadius = 5
        
        db = Firestore.firestore()
        
        /* Load WORLDWIDE Scores */
        db.collection("users").getDocuments() { [unowned self] (querySnapshot, error) in
            if let error = error {
                print("Error getting all user data for leaderboard, \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    self.allUsers.append(document.data())
                }
                print("Successfully got all user data for leaderboard.")
                
                for singleUser in self.allUsers {
                    let name = singleUser["name"] as? String ?? "Anon"
                    
                    //Put user's lowest time in Easy difficulty into the array
                    let nsEasy = singleUser["easyTime"] as? [NSNumber] ?? []
                    var easyScores = [(name: String, time: Int)]()
                    for num in nsEasy {
                        easyScores.append((name: name, time: num.intValue))
                    }
                    self.allEasyTime[1] += easyScores
                    
                    //Put user's lowest time in Hard difficulty into the array
                    let nsHard = singleUser["hardTime"] as? [NSNumber] ?? []
                    var hardScores = [(name: String, time: Int)]()
                    for num in nsHard {
                        hardScores.append((name: name, time: num.intValue))
                    }
                    self.allHardTime[1] += hardScores
                    
                    //Put user's lowest time in Impossible difficulty into the array
                    let nsImpossible = singleUser["impossibleTime"] as? [NSNumber] ?? []
                    var impossibleScores = [(name: String, time: Int)]()
                    for num in nsImpossible {
                        impossibleScores.append((name: name, time: num.intValue))
                    }
                    self.allImpossibleTime[1] += hardScores
                }
                //Sort all scores
                self.allEasyTime[1].sort(by: { $0.time < $1.time })
                self.allHardTime[1].sort(by: { $0.time < $1.time })
                self.allImpossibleTime[1].sort(by: { $0.time < $1.time })
                
                //Crop to top scores
                if self.allEasyTime[1].count > self.LIMIT {
                    self.allEasyTime[1] = Array(self.allEasyTime[1][0..<self.LIMIT])
                }
                if self.allHardTime[1].count > self.LIMIT {
                    self.allHardTime[1] = Array(self.allHardTime[1][0..<self.LIMIT])
                }
                if self.allImpossibleTime[1].count > self.LIMIT {
                    self.allImpossibleTime[1] = Array(self.allImpossibleTime[1][0..<self.LIMIT])
                }
                
            }
            
            self.leaderboardTable.reloadData()
        }
        
        if Auth.auth().currentUser!.isAnonymous {
            return
        }
        
        /* Load LOCAL Scores */
        let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.email ?? "")
        docRef.getDocument { [unowned self] (document, error) in
            if error != nil {
                return
            }
            if let document = document, document.exists {
                let easyNums: [NSNumber] = document["easyTime"] as? [NSNumber] ?? []
                for num in easyNums {
                    self.allEasyTime[0].append((document["name"] as? String ?? "Anon", num.intValue))
                }
                
                let hardNums: [NSNumber] = document["hardTime"] as? [NSNumber] ?? []
                for num in hardNums {
                    self.allHardTime[0].append((document["name"] as? String ?? "Anon", num.intValue))
                }
                
                let impossibleNums: [NSNumber] = document["impossibleTime"] as? [NSNumber] ?? []
                for num in impossibleNums {
                    self.allImpossibleTime[0].append((document["name"] as? String ?? "Anon", num.intValue))
                }
            }
            
            //Sort all scores
            self.allEasyTime[0].sort(by: { $0.time < $1.time })
            self.allHardTime[0].sort(by: { $0.time < $1.time })
            self.allImpossibleTime[0].sort(by: { $0.time < $1.time })
            
            //Crop to top scores
            if self.allEasyTime[0].count > self.LIMIT {
                self.allEasyTime[0] = Array(self.allEasyTime[0][0..<self.LIMIT])
            }
            if self.allHardTime[1].count > self.LIMIT {
                self.allHardTime[0] = Array(self.allHardTime[0][0..<self.LIMIT])
            }
            if self.allImpossibleTime[0].count > self.LIMIT {
                self.allImpossibleTime[0] = Array(self.allImpossibleTime[0][0..<self.LIMIT])
            }
            
            self.leaderboardTable.reloadData()
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
            return allEasyTime[section].count
        case 1:
            return allHardTime[section].count
        case 2:
            return allImpossibleTime[section].count
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
            cell.textLabel?.text = "\(indexPath.row + 1): " + allEasyTime[indexPath.section][indexPath.row].name
            cell.detailTextLabel?.text = "\(allEasyTime[indexPath.section][indexPath.row].time)s"
        case 1:
            cell.textLabel?.text = "\(indexPath.row + 1): " + allHardTime[indexPath.section][indexPath.row].name
            cell.detailTextLabel?.text = "\(allHardTime[indexPath.section][indexPath.row].time)s"
        case 2:
            cell.textLabel?.text = "\(indexPath.row + 1): " + allImpossibleTime[indexPath.section][indexPath.row].name
            cell.detailTextLabel?.text = "\(allImpossibleTime[indexPath.section][indexPath.row].time)s"
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allHardTime.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView ?? UITableViewHeaderFooterView()
        header.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.35)
        header.textLabel?.textColor = .black
        header.backgroundView?.backgroundColor = UIColor(red:  1, green: 215/255, blue: 165/255, alpha: 0.8)
        header.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = tableView.headerView(forSection: section) ?? UITableViewHeaderFooterView()
        header.backgroundColor = .green
        header.tintColor = .green
        
        if section == 0 {
            return "Local"
        }else {
            return "World Wide"
        }
    }
    
}
