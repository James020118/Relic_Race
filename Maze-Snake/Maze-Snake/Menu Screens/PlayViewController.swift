//
//  PlayViewController.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-23.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var impossibleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var aiClicked = false
    @IBAction func onPvAIClick(_ sender: Any) {
        //Toggle Difficult Options
        easyBtn.isHidden = aiClicked
        hardBtn.isHidden = aiClicked
        impossibleBtn.isHidden = aiClicked
        aiClicked = !aiClicked
    }
    
    var difficulty: Difficulty = .Easy
    @IBAction func onDifficultyClick(_ sender: Any) {
        guard let btn = sender as? UIButton else {
            return
        }
        switch btn {
        case easyBtn:
            difficulty = .Easy
        case hardBtn:
            difficulty = .Hard
        case impossibleBtn:
            difficulty = .Impossible
        default:
            print("None Match")
        }
        
        performSegue(withIdentifier: "pvAiSegue", sender: sender)
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let vc = segue.destination as? GameViewController else {
            return
        }
        // Pass the selected object to the new view controller.
        vc.difficulty = difficulty
    }

}
