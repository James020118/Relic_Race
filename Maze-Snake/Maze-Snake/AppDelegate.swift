//
//  AppDelegate.swift
//  Maze-Snake
//
//  Created by Period Four on 2019-05-02.
//  Copyright © 2019 YBMW. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds

let REWARD_UNIT_ID = "ca-app-pub-8803340854984368/9924557569"
let INTERSTITIAL_UNIT_ID = "ca-app-pub-8803340854984368/3195497686"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var db: Firestore!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: REWARD_UNIT_ID)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let gameScreen = application.topMostViewController() as? GameViewController else {
            return
        }
        if music_Is_On {
            gameScreen.soundController.stop()
        }
        gameScreen.aiGame!.timer.invalidate()
        gameScreen.aiGame!.isPaused = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let gameScreen = application.topMostViewController() as? GameViewController else {
            return
        }
        gameScreen.aiGame!.timer.invalidate()
        gameScreen.aiGame!.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            gameScreen.aiGame!.time += 1
            gameScreen.aiGame!.info.timerLabel.text = "Time Spent: " + gameScreen.aiGame!.formattedTime()
        })
        gameScreen.aiGame!.isPaused = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//MARK:- GADRewardBasedVideoAdDelegate

extension AppDelegate: GADRewardBasedVideoAdDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        if Auth.auth().currentUser!.isAnonymous {
            return
        }
        let currentUser = Auth.auth().currentUser!
        db.enableNetwork(completion: { (error) in
            let docRef = self.db.collection("users").document(currentUser.email!)
            docRef.getDocument { [unowned self] (document, error) in
                if error != nil {
                    self.db.disableNetwork(completion: nil)
                    return
                }
                if let document = document, document.exists {
                    let curRelics = document.data()!["currency"] as? Int ?? 0
                    var uData = document.data()!
                    uData["currency"] = curRelics + 10
                    self.db.collection("users").document(currentUser.email!).setData(uData)
                }
                self.db.disableNetwork(completion: nil)
            }
        })
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: REWARD_UNIT_ID)
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
        print(error)
        print(error.localizedDescription)
    }
}
