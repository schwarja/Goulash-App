//
//  Coordinating.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

protocol Coordinating {
    var childCoordinators: [Coordinating] { get }
    
    func start()
}
