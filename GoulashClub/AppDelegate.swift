//
//  AppDelegate.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    private(set) var coordinator: AppCoordinator!
    
    // MARK: App Lifecycle Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
        
        self.coordinator = AppCoordinator()
        
        if #available(iOS 13.0, *) {} else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            
            self.coordinator.startDefaultScene(with: window)
            
            self.window = window
        }
        
        if let item = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            coordinator.handle(shortcut: item)
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application will terminate - \(application)")
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("Application did receive memory warning - \(application)")
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        coordinator.handle(shortcut: shortcutItem)
        completionHandler(true)
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
        let isFromShortcut: Bool
        #if !targetEnvironment(macCatalyst)
        isFromShortcut = options.shortcutItem?.isDetailShortcut ?? false
        #else
        isFromShortcut = false
        #endif
        
        if options.userActivities.firstDetailSceneActivity != nil || isFromShortcut {
            return UISceneConfiguration(name: Constants.Scenes.detail.rawValue, sessionRole: connectingSceneSession.role)
        } else {
            return UISceneConfiguration(name: Constants.Scenes.default.rawValue, sessionRole: connectingSceneSession.role)
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        for session in sceneSessions {
            coordinator.didDestroy(sceneSession: session)
        }
    }
}

// MARK: Private methods
private extension AppDelegate {
    func configureFirebase() {
        guard let options = FirebaseOptions(contentsOfFile: Constants.Firebase.configUrl) else {
            fatalError("Can't configure Firebase")
        }
        FirebaseApp.configure(options: options)
    }
}
