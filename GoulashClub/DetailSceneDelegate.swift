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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let activity = connectionOptions
            .userActivities.firstDetailSceneActivity ?? session.stateRestorationActivity
        let sessionPlaceId = activity?.userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String
        
        let shortcutPlaceId: String?
        if let item = connectionOptions.shortcutItem, item.isDetailShortcut, let placeId = item.userInfo?[Constants.DetailShortcutItem.placeIdAttribute] as? NSString {
            shortcutPlaceId = placeId as String
        } else {
            shortcutPlaceId = nil
        }
        
        guard let placeId = sessionPlaceId ?? shortcutPlaceId else {
            appCoordinator.destroy(sceneSession: session)
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
                
        coordinator = appCoordinator.startPlaceScene(for: session, placeId: placeId, with: window)

        self.window = window
        
        let handOffPredicate = NSPredicate(format: "self == %@", "\(Constants.DetailSceneActivity.type)/\(placeId)")
        let shortcutPredicate = NSPredicate(format: "self == %@", "\(Constants.DetailShortcutItem.targetContentIdentifierPrefix)/\(placeId)")
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [handOffPredicate, shortcutPredicate])
        scene.activationConditions.canActivateForTargetContentIdentifierPredicate = compoundPredicate
        scene.activationConditions.prefersToActivateForTargetContentIdentifierPredicate = compoundPredicate
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return coordinator?.restorationActivity
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("Continue user activity: \(userActivity)")
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.isDetailShortcut, let placeId = shortcutItem.userInfo?[Constants.DetailShortcutItem.placeIdAttribute] as? NSString {
            completionHandler(placeId as String == coordinator?.placeId)
        } else {
            completionHandler(false)
        }
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
