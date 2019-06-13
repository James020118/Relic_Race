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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var gameScreen: GameViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        print(db)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let gameScreen = AppDelegate.gameScreen else {
            return
        }
        if music_Is_On {
            gameScreen.soundController.stop()
        }
        gameScreen.aiGame.timer.invalidate()
        gameScreen.aiGame.isPaused = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let gameScreen = AppDelegate.gameScreen else {
            return
        }
        gameScreen.aiGame.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            gameScreen.aiGame.time += 1
            gameScreen.aiGame.info.timerLabel.text = "Time Spent: " + gameScreen.aiGame.formattedTime()
        })
        gameScreen.aiGame.isPaused = false
        AppDelegate.gameScreen = nil
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

