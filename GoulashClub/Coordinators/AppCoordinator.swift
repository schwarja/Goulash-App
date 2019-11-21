//
//  AppCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinating {
    let dependencies: AppDependencable
    
    private(set) var childCoordinators: [Coordinating] = []
    @available(iOS 13.0, *)
    private(set) lazy var activeSessions: [Constants.Scenes: [String: UISceneSession]] = [:]
    
    init() {
        dependencies = AppDependency()
    }
    
    func start() {
        
    }
    
    func startDefaultScene(with window: UIWindow) {
        let coordinator = DefaultCoordinator(dependencies: dependencies, window: window)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func startPlaceScene(for placeId: String, with window: UIWindow) {
        let coordinator = DetailCoordinator(dependencies: dependencies, placeId: placeId, window: window)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    @available(iOS 13.0, *)
    func didCreate(sceneSession: UISceneSession, for placeId: String) {
        var sessions = activeSessions[.detail] ?? [:]
        sessions[placeId] = sceneSession
        activeSessions[.detail] = sessions
    }
    
    @available(iOS 13.0, *)
    func didDestroy(sceneSession: UISceneSession) {
        var activeSessionsCopy = activeSessions
        for (scene, dictionary) in activeSessions {
            for (id, session) in dictionary where session == sceneSession {
                activeSessionsCopy[scene]?[id] = nil
            }
        }
        activeSessions = activeSessionsCopy
    }
}

// MARK: Default coordinator delegate
extension AppCoordinator: DefaultCoordinatorDelegate {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String, from coordinator: DefaultCoordinator) {
        requestPlaceScene(for: placeId, from: coordinator)
    }
}

// MARK: Private methods
@available(iOS 13.0, *)
private extension AppCoordinator {
    func userActivity(for placeId: String) -> NSUserActivity {
        let activity = NSUserActivity(activityType: Constants.PlaceDetailActivity.type)
        
        activity.requiredUserInfoKeys = [Constants.PlaceDetailActivity.placeIdAttribute]
        activity.userInfo = [Constants.PlaceDetailActivity.placeIdAttribute: placeId]
        
        return activity
    }
    
    func sceneSession(for placeId: String) -> UISceneSession? {
        return activeSessions[.detail]?[placeId]
    }
    
    func requestPlaceScene(for placeId: String, from coordinator: DefaultCoordinator) {
        let session = sceneSession(for: placeId)
        let activity = userActivity(for: placeId)
        let options = UIScene.ActivationRequestOptions()
        options.requestingScene = coordinator.window.windowScene
        UIApplication.shared.requestSceneSessionActivation(session, userActivity: activity, options: options, errorHandler: nil)
    }
}
