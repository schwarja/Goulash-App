//
//  MainCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 05/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DefaultCoordinator {
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let split = GoulashSplitViewController()
        
        let list = PlacesViewController()
        let listNavigation = GoulashNavigationController(rootViewController: list)
        
        let detail = DetailViewController()
        let detailNavigation = GoulashNavigationController(rootViewController: detail)
        
        split.viewControllers = [listNavigation, detailNavigation]
        
        window.rootViewController = split
        window.makeKeyAndVisible()
    }
}
