//
//  NSUserActivitySet+Scenes.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 21/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

extension Set where Element == NSUserActivity {
    var containsDetailSceneActivity: Bool {
        self.contains(where: { $0.activityType == Constants.DetailSceneActivity.type })
    }
    
    var firstDetailSceneActivity: NSUserActivity? {
        self.first(where: { $0.activityType == Constants.DetailSceneActivity.type })
    }
}
