//
//  PlaceSceneDelegate.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 21/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class DetailSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: DetailCoordinator?
    private weak var session: UISceneSession?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let activity = connectionOptions
            .userActivities.firstDetailSceneActivity ?? session.stateRestorationActivity
        let sessionPlaceId = activity?.userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String
        
        let shortcutPlaceId: String?
        if let item = connectionOptions.shortcutItem, item.isDetailShortcut, let placeId = item.userInfo?[Constants.DetailShortcutItem.placeIdAttribute] as? String {
            shortcutPlaceId = placeId
        } else {
            shortcutPlaceId = nil
        }
        
        let window = UIWindow(windowScene: windowScene)
                
        if let placeId = sessionPlaceId ?? shortcutPlaceId {
            configureScene(for: placeId, with: window, session: session)
        } else if connectionOptions.handoffUserActivityType != Constants.DetailSceneActivity.type {
            appCoordinator.destroy(sceneSession: session)
            return
        }
        
        self.session = session
        self.window = window
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return coordinator?.restorationActivity
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("Continue user activity: \(userActivity)")
        
        if userActivity.activityType == Constants.DetailSceneActivity.type,
            let placeId = userActivity.userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String,
            placeId != coordinator?.placeId,
            let window = window,
            let session = session {
            
            configureScene(for: placeId, with: window, session: session)
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.isDetailShortcut, let placeId = shortcutItem.userInfo?[Constants.DetailShortcutItem.placeIdAttribute] as? String {
            if placeId != coordinator?.placeId,
                let window = window,
                let session = session {
                
                configureScene(for: placeId, with: window, session: session)
            }
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene did disconnect - \(scene.title ?? "")")
        
        discardCurrentConfiguration()
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
private extension DetailSceneDelegate {
    func configureScene(for placeId: String, with window: UIWindow, session: UISceneSession) {
        appCoordinator.didDestroy(sceneSession: session)
        discardCurrentConfiguration()
                
        coordinator = appCoordinator.startPlaceScene(for: session, placeId: placeId, with: window)
        
        if let scene = window.windowScene {
            let handOffPredicate = NSPredicate(format: "self == %@", "\(Constants.DetailSceneActivity.type)/\(placeId)")
            let shortcutPredicate = NSPredicate(format: "self == %@", "\(Constants.DetailShortcutItem.targetContentIdentifierPrefix)/\(placeId)")
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [handOffPredicate, shortcutPredicate])
            scene.activationConditions.canActivateForTargetContentIdentifierPredicate = compoundPredicate
            scene.activationConditions.prefersToActivateForTargetContentIdentifierPredicate = compoundPredicate
        }
    }
    
    func discardCurrentConfiguration() {
        if let coordinator = coordinator {
            appCoordinator.discard(coordinator: coordinator)
        }
    }
}
