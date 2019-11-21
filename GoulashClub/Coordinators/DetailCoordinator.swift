//
//  PlaceCoordinator.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 21/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

protocol DetailCoordinatorDelegate: class {
    @available(iOS 13.0, *)
    func requestSceneForPlace(with placeId: String)
}

class DetailCoordinator: Coordinating {
    let window: UIWindow?
    let rootViewController = GoulashNavigationController()
    let placeId: String
    
    weak var delegate: DetailCoordinatorDelegate?
    
    private(set) var childCoordinators: [Coordinating] = []
    private let dependencies: AppDependencable

    init(dependencies: AppDependencable, placeId: String, window: UIWindow? = nil) {
        self.dependencies = dependencies
        self.placeId = placeId
        self.window = window
    }

    func start() {
        let viewModel = DetailViewModel(placeId: placeId, database: dependencies.databaseManager)
        let detail = DetailViewController(viewModel: viewModel, coordinator: self)
        rootViewController.setViewControllers([detail], animated: false)
        
        if let window = window {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: Actions
extension DetailCoordinator {
    func didSelectOpenInNewWindow(in controller: DetailViewController) {
        if #available(iOS 13.0, *) {
            delegate?.requestSceneForPlace(with: placeId)
        }
    }
}
