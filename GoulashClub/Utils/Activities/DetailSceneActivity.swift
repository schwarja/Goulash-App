//
//  DetailSceneActivity.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 26/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

class DetailSceneActivity: NSUserActivity {
    var placeId: String {
        userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String ?? ""
    }
    
    init(placeId: String) {
        super.init(activityType: Constants.DetailSceneActivity.type)
        
        self.requiredUserInfoKeys = [Constants.DetailSceneActivity.placeIdAttribute]
        self.userInfo = [Constants.DetailSceneActivity.placeIdAttribute: placeId]
    }
}
