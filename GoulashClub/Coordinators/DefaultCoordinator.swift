//
//  MainCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 05/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DefaultCoordinator: NSObject, Coordinating {
    let splitViewController = GoulashSplitViewController()
    private lazy var masterViewController: GoulashNavigationController = {
        let viewModel = PlacesViewModel(database: dependencies.databaseManager)
        let list = PlacesViewController(viewModel: viewModel, coordinator: self)
        let listNavigation = GoulashNavigationController(rootViewController: list)
        return listNavigation
    }()
    
    private var window: UIWindow
    private let dependencies: AppDependencable
    
    private(set) var childCoordinators: [Coordinating] = []

    init(window: UIWindow, dependencies: AppDependencable) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        dependencies.databaseManager.register(placesListener: self)
        
        splitViewController.viewControllers = [masterViewController]
        
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

// MARK: Private method
private extension DefaultCoordinator {
    func presentDetail(for place: Place) {
        let viewModel = DetailViewModel(placeId: place.id, database: dependencies.databaseManager)
        let detail = DetailViewController(viewModel: viewModel)
        let detailNavigation = GoulashNavigationController(rootViewController: detail)

        splitViewController.viewControllers = [masterViewController, detailNavigation]
    }
}
