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
    private var coordinator: DefaultCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
                
        coordinator = appCoordinator.startDefaultScene(with: window)
        
        if let activity = connectionOptions.userActivities.firstDetailSceneActivity,
            let placeId = activity.userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String {
            
            coordinator?.showDetail(for: placeId)
        } else if let activity = session.stateRestorationActivity,
            let placeId = activity.userInfo?[Constants.DefaultSceneActivity.placeIdAttribute] as? String {
            
            coordinator?.showDetail(for: placeId)
        }

        
        #if !targetEnvironment(macCatalyst)
        if let item = connectionOptions.shortcutItem {
            process(shortcutItem: item)
        }
        #endif

        self.window = window
        
        scene.activationConditions.canActivateForTargetContentIdentifierPredicate = NSPredicate(format: "self == %@", Constants.DefaultSceneActivity.type)
        scene.activationConditions.prefersToActivateForTargetContentIdentifierPredicate = NSPredicate(format: "self == %@", Constants.DefaultSceneActivity.type)
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return coordinator?.restorationActivity
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("Continue user activity: \(userActivity)")
        
        if userActivity.activityType == Constants.DetailSceneActivity.type,
            let placeId = userActivity.userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String {
            coordinator?.showDetail(for: placeId)
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        process(shortcutItem: shortcutItem)
        completionHandler(true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene did disconnect - \(scene.title ?? "")")
        
        if let coordinator = coordinator {
            appCoordinator.discard(coordinator: coordinator)
        }
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

// MARK: Private methods
@available(iOS 13.0, *)
private extension DefaultSceneDelegate {
    func process(shortcutItem: UIApplicationShortcutItem) {
        if shortcutItem.isDetailShortcut, let placeId = shortcutItem.userInfo?[Constants.DetailShortcutItem.placeIdAttribute] as? String {
            coordinator?.showDetail(for: placeId)
        }
    }
}
