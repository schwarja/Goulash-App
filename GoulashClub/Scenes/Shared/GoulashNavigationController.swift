//
//  GoulashNavigationController.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class GoulashNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if visibleViewController != nil {
            visibleViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: Private methods
private extension GoulashNavigationController {
    func setupUI() {
        navigationBar.barTintColor = .appBackground
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appText, .font: UIFont.appSubtitle]
        navigationBar.tintColor = .appText
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.appText, .font: UIFont.appTitle]
    }
}
