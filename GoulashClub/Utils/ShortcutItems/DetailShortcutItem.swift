//
//  DetailShortcutItem.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 06/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

class DetailShortcutItem: UIMutableApplicationShortcutItem {
    var placeId: NSString? {
        userInfo?[Constants.DetailShortcutItem.type] as? NSString
    }
    
    init(placeId: String, name: String?) {
        super.init(
            type: Constants.DetailShortcutItem.type,
            localizedTitle: name ?? "Goulash Place",
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(type: .markLocation),
            userInfo: [Constants.DetailShortcutItem.placeIdAttribute: placeId as NSString]
        )
        
        targetContentIdentifier = "\(Constants.DetailShortcutItem.targetContentIdentifierPrefix)/\(placeId)"
    }
}
