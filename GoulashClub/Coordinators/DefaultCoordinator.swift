//
//  MainCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 05/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DefaultCoordinator: Coordinating {
    private var window: UIWindow
    private let dependencies: AppDependencable
    
    private(set) var childCoordinators: [Coordinating] = []

    init(window: UIWindow, dependencies: AppDependencable) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        let split = GoulashSplitViewController()
        
        let viewModel = PlacesViewModel(database: dependencies.databaseManager)
        let list = PlacesViewController(viewModel: viewModel)
        let listNavigation = GoulashNavigationController(rootViewController: list)
        
        let detail = DetailViewController()
        let detailNavigation = GoulashNavigationController(rootViewController: detail)
        
        split.viewControllers = [listNavigation, detailNavigation]
        
        window.rootViewController = split
        window.makeKeyAndVisible()
    }
}
