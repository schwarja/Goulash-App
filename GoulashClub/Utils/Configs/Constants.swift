//
//  Constants.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

enum Constants {
    enum Scenes: String {
        case `default` = "DefaultSceneConfiguration"
        case detail = "DetailSceneConfiguration"
    }
    
    enum Firebase {
        #if targetEnvironment(macCatalyst)
        // swiftlint:disable:next force_unwrapping
        static let configUrl = Bundle.main.path(forResource: "GoogleService-Mac", ofType: "plist")!
        #else
        // swiftlint:disable:next force_unwrapping
        static let configUrl = Bundle.main.path(forResource: "GoogleService-iOS", ofType: "plist")!
        #endif
        static let defaultIdAttributeName = "id"
    }
    
    enum PlaceScene {
        static let placeIdAttribute = "placeId"
    }
    
    enum PlaceDetailActivity {
        static let type = "placeDetail"
        static let placeIdAttribute = "placeId"
    }
}
