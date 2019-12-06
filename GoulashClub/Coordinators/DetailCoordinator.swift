//
//  PlaceCoordinator.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 21/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

protocol DetailCoordinatorInWindowDelegate: class {
    @available(iOS 13.0, *)
    func closeWindow(for placeId: String)
}

protocol DetailCoordinatorInSplitDelegate: class {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String)
}

class DetailCoordinator: NSObject, Coordinating, Restorable {
    let identifier = UUID().uuidString
    let window: UIWindow?
    let rootViewController = GoulashNavigationController()
    let placeId: String
    
    weak var delegateInSplitView: DetailCoordinatorInSplitDelegate?
    weak var delegateInWindow: DetailCoordinatorInWindowDelegate?
    
    private(set) var childCoordinators: [Coordinating] = []
    private let dependencies: AppDependencable
    
    lazy var restorationActivity: DetailSceneActivity? = {
        let activity = DetailSceneActivity(placeId: placeId)
        return activity
    }()

    init(dependencies: AppDependencable, placeId: String, window: UIWindow? = nil) {
        self.dependencies = dependencies
        self.placeId = placeId
        self.window = window
    }
    
    deinit {
        restorationActivity?.resignCurrent()
    }

    func start() {
        let viewModel = DetailViewModel(placeId: placeId, database: dependencies.databaseManager)
        let canRequestNewWindow: Bool
        if #available(iOS 13.0, *) {
            canRequestNewWindow = UIApplication.shared.supportsMultipleScenes
        } else {
            canRequestNewWindow = false
        }
        let canBeDismissed = window != nil
        let dependency = DetailViewController.Dependency(
            viewModel: viewModel,
            coordinator: self,
            canRequestNewWindow: canRequestNewWindow && !canBeDismissed,
            canBeDismissed: canBeDismissed
        )
        let detail = DetailViewController(dependency: dependency)
        rootViewController.setViewControllers([detail], animated: false)
        
        restorationActivity?.becomeCurrent()
        
        configureShortcutItem()
        
        dependencies.databaseManager.register(placeListener: self, for: placeId)

        if let window = window {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: Place listener
extension DetailCoordinator: PlaceDatabaseListener {
    func didUpdatePlace(with id: String, place: DataStatus<Place>) {
        if case .ready(let item) = place {
            configureShortcutItem(with: item)
        }
    }
}

// MARK: Private methods
private extension DetailCoordinator {
    func configureShortcutItem(with place: Place? = nil) {
        var items = UIApplication.shared.shortcutItems ?? []
        items = items.filter({ !$0.isDetailShortcut })
        
        let item = DetailShortcutItem(placeId: placeId, name: place?.name)
        items.append(item)
        UIApplication.shared.shortcutItems = items
    }
}

// MARK: Actions
extension DetailCoordinator {
    func didSelectOpenInNewWindow(in controller: DetailViewController) {
        if #available(iOS 13.0, *) {
            delegateInSplitView?.requestSceneForPlace(with: placeId)
        }
    }
    
    func didSelectClose(in controller: DetailViewController) {
        if #available(iOS 13.0, *) {
            delegateInWindow?.closeWindow(for: placeId)
        }
    }
}
