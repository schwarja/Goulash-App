//
//  ListCoordinator.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 21/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol ListCoordinatorDelegate: class {
    func presentDetail(for place: Place)
}

class ListCoordinator: Coordinating {
    let rootViewController = GoulashNavigationController()
    
    weak var delegate: ListCoordinatorDelegate?

    private(set) var childCoordinators: [Coordinating] = []
    private let dependencies: AppDependencable
    
    init(dependencies: AppDependencable, delegate: ListCoordinatorDelegate) {
        self.dependencies = dependencies
        self.delegate = delegate
    }

    func start() {
        let viewModel = PlacesViewModel(database: dependencies.databaseManager)
        let list = PlacesViewController(viewModel: viewModel, coordinator: self)
        
        rootViewController.setViewControllers([list], animated: false)
    }
}

// MARK: Actions
extension ListCoordinator {
    func didSelect(place: Place, in viewController: PlacesViewController) {
        delegate?.presentDetail(for: place)
    }
}
