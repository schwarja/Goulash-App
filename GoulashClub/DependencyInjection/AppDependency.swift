//
//  AppDependency.swift
//  GoulashClub
//
//  Created by Jan on 18/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

struct AppDependency: AppDependencable {
    let databaseManager: DatabaseManaging
    
    init() {
        self.databaseManager = FirebaseManager()
    }
}
