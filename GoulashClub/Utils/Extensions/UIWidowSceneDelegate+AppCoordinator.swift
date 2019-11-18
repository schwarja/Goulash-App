//
//  UIWidowSceneDelegate+AppCoordinator.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension UIWindowSceneDelegate {
    var appCoordinator: AppCoordinator {
        return (UIApplication.shared.delegate as? AppDelegate)!.coordinator
    }
}
