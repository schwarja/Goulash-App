//
//  AppDelegate.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var coordinator: AppCoordinator!
    // MARK: Coordinator for iOS 12 and sooner
    private var defaultCoordinator: DefaultCoordinator?
    
    // MARK: App Lifecycle Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.coordinator = AppCoordinator()
        
        if #available(iOS 13.0, *) {} else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            
            defaultCoordinator = DefaultCoordinator(window: window)
            defaultCoordinator?.start()
            
            self.window = window
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application will terminate - \(application)")
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("Application did receive memory warning - \(application)")
    }
}
 
// MARK: UI Lifecycle Methods
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application did become active - \(application)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Application will resign active - \(application)")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application will enter foreground - \(application)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application did enter background - \(application)")
    }
}

// MARK: UISceneSession Lifecycle
@available(iOS 13.0, *)
extension AppDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: Constants.Scenes.default, sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

