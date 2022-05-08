//
//  AppDelegate.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import Appirater
import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Appirater.appLaunched(true)
        Appirater.setDebug(false)
        Appirater.setAppId("34882823481234781")
        Appirater.setDaysUntilPrompt(7)
        
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = TabBarViewController()
        window.makeKeyAndVisible()
        self.window = window

        FirebaseApp.configure()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
