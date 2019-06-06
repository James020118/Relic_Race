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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
