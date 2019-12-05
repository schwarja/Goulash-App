//
//  Constants.swift
//  GoulashClub
//
//  Created by Jan on 04/11/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import Foundation

enum Constants {
    enum App {
        // swiftlint:disable:next force_unwrapping
        static let bundleId = Bundle.main.bundleIdentifier!
    }
    
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
    
    enum DetailSceneActivity {
        static let type = "\(App.bundleId).placeDetail"
        static let placeIdAttribute = "placeId"
    }
    
    enum DefaultSceneActivity {
        static let type = "\(App.bundleId).default"
        static let placeIdAttribute = "placeId"
    }
}
