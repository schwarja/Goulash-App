//
//  Restorable.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 26/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol Restorable {
    associatedtype UserActivity: NSUserActivity
    
    var restorationActivity: UserActivity? { get }
}
