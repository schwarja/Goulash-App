//
//  AppDependencable.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

protocol AppDependencable {
    var databaseManager: DatabaseManaging { get }
}
