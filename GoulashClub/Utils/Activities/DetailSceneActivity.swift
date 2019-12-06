//
//  DetailSceneActivity.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 26/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation
import Intents
import CoreSpotlight
import CoreServices

class DetailSceneActivity: NSUserActivity {
    var placeId: String {
        userInfo?[Constants.DetailSceneActivity.placeIdAttribute] as? String ?? ""
    }
    
    init(placeId: String) {
        super.init(activityType: Constants.DetailSceneActivity.type)
        
        self.requiredUserInfoKeys = [Constants.DetailSceneActivity.placeIdAttribute]
        self.userInfo = [Constants.DetailSceneActivity.placeIdAttribute: placeId]
        
        self.isEligibleForSearch = true
        self.isEligibleForPrediction = true
        
        if #available(iOS 13.0, *) {
            self.targetContentIdentifier = "\(self.activityType)/\(placeId)"
        }
    }
    
    func update(with place: Place) {
        self.title = place.name
        self.suggestedInvocationPhrase = "Show goulash restuarant called \(place.name)"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.contentDescription = "Goulash restaurant \(place.name)"
        self.contentAttributeSet = attributes
    }
}
