//
//  UIApplicationShortcutItem+Convenience.swift
//  GoulashClub
//
//  Created by Jan Schwarz on 06/12/2019.
//  Copyright © 2019 Jan Schwarz. All rights reserved.
//

import UIKit

extension UIApplicationShortcutItem {
    var isDetailShortcut: Bool {
        self.type == Constants.DetailShortcutItem.type
    }
}
