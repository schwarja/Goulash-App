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
    
    init() {
        dependencies = AppDependency()
    }
    
    func start() {
        
    }
    
    func startDefaultScene(with window: UIWindow) {
        let defaultCoordinator = DefaultCoordinator(window: window, dependencies: dependencies)
        childCoordinators.append(defaultCoordinator)
        
        defaultCoordinator.start()
    }
}
