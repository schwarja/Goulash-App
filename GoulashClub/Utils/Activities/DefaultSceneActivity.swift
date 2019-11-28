//
//  DefaultSceneActivity.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 26/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

class DefaultSceneActivity: NSUserActivity {
    var placeId: String? {
        userInfo?[Constants.DefaultSceneActivity.placeIdAttribute] as? String
    }
    
    init() {
        super.init(activityType: Constants.DefaultSceneActivity.type)
    }
    
    func didOpenDetail(for placeId: String) {
        addUserInfoEntries(from: [Constants.DefaultSceneActivity.placeIdAttribute: placeId])
    }
    
    func didCloseDetail() {
        userInfo?[Constants.DefaultSceneActivity.placeIdAttribute] = nil
    }
}
