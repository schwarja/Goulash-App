//
//  MainCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 05/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

protocol DefaultCoordinatorDelegate: class {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String, from coordinator: DefaultCoordinator)
}

class DefaultCoordinator: NSObject, Coordinating {
    let splitViewController = GoulashSplitViewController()
    weak var delegate: DefaultCoordinatorDelegate?
    
    let window: UIWindow
    let dependencies: AppDependencable
    
    private lazy var masterCoordinator: ListCoordinator = {
        ListCoordinator(dependencies: self.dependencies, delegate: self)
    }()
    
    private(set) var childCoordinators: [Coordinating] = []

    init(dependencies: AppDependencable, window: UIWindow) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        dependencies.databaseManager.register(placesListener: self)
        
        childCoordinators.append(masterCoordinator)
        masterCoordinator.start()
        splitViewController.viewControllers = [masterCoordinator.rootViewController]
        
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
    }
}

// MARK: Places listener
extension DefaultCoordinator: PlacesDatabaseListener {
    func didUpdatePlaces(_ places: DataStatus<[Place]>) {
        if case .ready(let places) = places, splitViewController.viewControllers.count == 1, let place = places.first {
            presentDetail(for: place)
        }
    }
}

// MARK: Actions
extension DefaultCoordinator {
    func didSelect(place: Place, in controller: PlacesViewController) {
        presentDetail(for: place)
    }
}

// MARK: List coordinator delegate
extension DefaultCoordinator: ListCoordinatorDelegate {
    func presentDetail(for place: Place) {
        childCoordinators = childCoordinators.filter({ $0 is ListCoordinator })
        
        let detailCoordinator = DetailCoordinator(dependencies: dependencies, placeId: place.id)
        detailCoordinator.delegate = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()

        splitViewController.viewControllers = [masterCoordinator.rootViewController, detailCoordinator.rootViewController]
    }
}

// MARK: Detail coordinator delegate
extension DefaultCoordinator: DetailCoordinatorDelegate {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String) {
        delegate?.requestSceneForPlace(with: placeId, from: self)
    }
}
