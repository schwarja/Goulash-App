//
//  SceneDelegate.swift
//  GoulashClub
//
//  Created by Jan on 31/10/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class DefaultSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var coordinator: DefaultCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
                
        self.coordinator = DefaultCoordinator(window: window)
        self.coordinator.start()

        self.window = window
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("Continue user activity: \(userActivity)")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene did disconnect - \(scene.title ?? "")")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene did become active - \(scene.title ?? "")")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene will resign active - \(scene.title ?? "")")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Scene will enter foreground - \(scene.title ?? "")")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Scene did enter background - \(scene.title ?? "")")
    }
}

