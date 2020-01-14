//
//  AppDelegate.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 07/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // We use this methode to make the bar item that are not selected dark grey
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        
        // We use this methode to change the caret's TextField color
        UITextField.appearance().tintColor = UIColor.white
        
        // We use this to change the caret's textView color
        UITextView.appearance().tintColor = UIColor.white
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
