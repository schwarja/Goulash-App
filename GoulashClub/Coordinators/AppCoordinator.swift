//
//  AppCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinating {
    let identifier = UUID().uuidString
    let dependencies: AppDependencable
    
    private(set) var childCoordinators: [Coordinating] = []
    @available(iOS 13.0, *)
    private(set) lazy var activeSessions: [Constants.Scenes: [String: UISceneSession]] = [:]
    
    init() {
        dependencies = AppDependency()
    }
    
    func start() {
        
    }
    
    @discardableResult
    func startDefaultScene(with window: UIWindow) -> DefaultCoordinator {
        let coordinator = DefaultCoordinator(dependencies: dependencies, window: window)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        
        coordinator.start()
        
        return coordinator
    }
    
    func discard(coordinator: Coordinating) {
        if let index = childCoordinators.firstIndex(where: { $0.identifier == coordinator.identifier }) {
            childCoordinators.remove(at: index)
        }
    }
}
 
// MARK: Scenes management
@available(iOS 13.0, *)
extension AppCoordinator {
    func startDefaultScene(for session: UISceneSession, with window: UIWindow) -> DefaultCoordinator {
        var sessions = activeSessions[.default] ?? [:]
        sessions[Constants.Scenes.default.rawValue] = session
        activeSessions[.default] = sessions
        
        return startDefaultScene(with: window)
    }
    
    func startPlaceScene(for session: UISceneSession, placeId: String, with window: UIWindow) -> DetailCoordinator {
        var sessions = activeSessions[.detail] ?? [:]
        sessions[placeId] = session
        activeSessions[.detail] = sessions

        let coordinator = DetailCoordinator(dependencies: dependencies, placeId: placeId, window: window)
        coordinator.delegateInWindow = self
        childCoordinators.append(coordinator)
        
        coordinator.start()
        
        return coordinator
    }
    
    func destroy(sceneSession: UISceneSession) {
        let options = UIWindowSceneDestructionRequestOptions()
        options.windowDismissalAnimation = .decline
        UIApplication.shared.requestSceneSessionDestruction(sceneSession, options: options, errorHandler: nil)
    }
    
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

// MARK: Detail coordinator delegate
extension AppCoordinator: DetailCoordinatorInWindowDelegate {
    @available(iOS 13.0, *)
    func closeWindow(for placeId: String) {
        guard let session = activeSessions[.detail]?[placeId] else {
            return
        }
        
        let options = UIWindowSceneDestructionRequestOptions()
        options.windowDismissalAnimation = .standard
        UIApplication.shared.requestSceneSessionDestruction(session, options: options, errorHandler: nil)
    }
}

// MARK: Private methods
@available(iOS 13.0, *)
private extension AppCoordinator {
    func sceneSession(for placeId: String) -> UISceneSession? {
        return activeSessions[.detail]?[placeId]
    }
    
    func requestPlaceScene(for placeId: String, from coordinator: DefaultCoordinator) {
        let session = sceneSession(for: placeId)
        let activity = DetailSceneActivity(placeId: placeId)
        let options = UIScene.ActivationRequestOptions()
        options.requestingScene = coordinator.window.windowScene
        UIApplication.shared.requestSceneSessionActivation(session, userActivity: activity, options: options, errorHandler: nil)
    }
}
